
import condCodes as cc
import mne
from mne import fiff
from mne.epochs import combine_event_ids
import numpy as np
import argparse
import copy
from mne import Epochs
from mne.epochs import equalize_epoch_counts
import numpy
from mne import epochs

#######Get input######
parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('subj',type=str)
#parser.add_argument('exp',type=str)
args=parser.parse_args()

print args.subj
exp = 'AXCPTtar'
print exp
expName = 'AXCPT'

#######Analysis parameters######
###Event file suffix (e.g., artifact rejection applied?)
evSuffix = 'ModRej.eve'

###Projection and Average Reference 
projVal = True
avgRefVal = False

###Filtering
hp_cutoff = None
lp_cutoff = 20

#######Experiment specific parameters###### 
###Runs
runs = cc.runDict[exp]
if args.subj == 'ac8' and exp == 'BaleenLP':
    runs = ['Run1','Run3','Run4']

###EventLabels
labelList = cc.condLabels[exp]
event_id = {}
for row in labelList:
    event_id[row[1]] = int(row[0])
print event_id

###TimeWindow
tmin = -.1
tmax = float(cc.epMax[exp])

############################################
########Artifact rejection parameters######

###General
gradRej = 2000e-13
magRej = 3000e-15
eegRej = 100e-6
magFlat = 1e-14
gradFlat = 1000e-15

###Subject-specific
if args.subj == "ya31":
    magRej = 4000e-15 ##note exception for ya31 and sc9, whose magnetometers were baseline noisy
if args.subj == "ya5" or args.subj == "ya21" or args.subj == "ya18" or args.subj == "ya27" or args.subj == "ya31":
    eegRej = 150e-6  ##note because of alpha for ya21
if args.subj == "ya23":
    eegRej = 125e-6
if args.subj == "ya15":
    eegRej = 80e-6
if args.subj == "ya26":
    eegRej = 90e-6


###########################################
########Compute averages for each run######
event_id = {'BYtarget': 3, 'BXtarget': 2, 'AXtarget': 4, 'AYtarget': 1}
evokedRuns = []
epochs_eq = []
evokeds = []
ep =[]
for evRun in runs:
    evokeds = []

    ###Get Subject and run-specific parameters
    print evRun
    data_path = '/cluster/kuperberg/SemPrMM/MEG/data/'+args.subj+'/'
    event_fname = data_path + 'eve/' + args.subj + '_' + expName+evRun + evSuffix
    #event_fname = data_path  + args.subj + '_' + expName+evRun + evSuffix      
    print event_fname
    raw_fname = data_path + args.subj+'_'+ expName +evRun+'_ssp_raw.fif' ##Using ssp because for only for ya12, ya27, ya31 AXCPT- ecg SSP has been perfrmed, rest have been sym-linked to the raw file. 
    avg_log_fname = data_path + 'ave_projon/logs/' +args.subj+ '_'+expName + evRun +'-equaliseTar-test-ave.log' ##CHANGE THIS
    

    ###Setup for reading the original raw data and events
    raw = fiff.Raw(raw_fname, preload=True)
    events = mne.read_events(event_fname)
    raw_skip = raw.first_samp
    mne.set_log_file(fname = avg_log_fname, overwrite = True)

    ###Correct events for the fact that ssp data has the skip removed
    if (args.subj == "ya12") or (args.subj == 'ya27') or (args.subj == 'ya31'):
        print "Adjusting events for SSP raw.fif files"
        for row in events:
            row[0] = row[0]-raw_skip


    ###Filter raw data
    fiff.Raw.filter(raw,l_freq=hp_cutoff,h_freq=lp_cutoff)

    ###Pick all channels, including stimulus triggers
    picks = []
    for i in range(raw.info['nchan']):
        picks.append(i)

    ###Printing  total number of events in all available conditions from the event file     
    print "Available events from the file %s" % (event_fname)
    event_ids = np.unique(events[:, -1])
    #for ev_id in event_ids:
         #print '%d : %d' % (ev_id, np.sum(events[:, -1] == ev_id))

    ###Read epochs
    epochsAY = mne.Epochs(raw, events, event_id['AYtarget'], tmin, tmax, name = 'AYtarget', picks=picks, baseline=(None, 0),add_eeg_ref=avgRefVal, proj=projVal,reject=dict(eeg=eegRej,mag=magRej,grad=gradRej),flat=dict(mag=magFlat, grad=gradFlat))
    epochsBX = mne.Epochs(raw, events, event_id['BXtarget'], tmin, tmax, name = 'BXtarget', picks=picks,baseline=(None, 0),add_eeg_ref=avgRefVal, proj=projVal,reject=dict(eeg=eegRej,mag=magRej,grad=gradRej),flat=dict(mag=magFlat, grad=gradFlat))
    epochsBY = mne.Epochs(raw, events, event_id['BYtarget'], tmin, tmax, name = 'BYtarget', picks=picks,baseline=(None, 0),add_eeg_ref=avgRefVal, proj=projVal,reject=dict(eeg=eegRej,mag=magRej,grad=gradRej),flat=dict(mag=magFlat, grad=gradFlat))
    epochsAX = mne.Epochs(raw, events, event_id['AXtarget'], tmin, tmax, name = 'AXtarget', picks=picks, baseline=(None, 0),add_eeg_ref=avgRefVal, proj=projVal,reject=dict(eeg=eegRej,mag=magRej,grad=gradRej),flat=dict(mag=magFlat, grad=gradFlat))                       
#    epochs = mne.Epochs(raw, events, event_id, tmin, tmax) ## picks=picks, baseline=(None, 0),add_eeg_ref=avgRefVal, proj=projVal,reject=dict(eeg=eegRej,mag=magRej,grad=gradRej),flat=dict(mag=magFlat, grad=gradFlat))
#    print epochs

    print "Epochs before equalising"
    print epochsAX
    print epochsBX
    print epochsAY
    print epochsBY
   
    ###Equalising A and B target trials for AXCPT - YA
    mne.epochs.equalize_epoch_counts([epochsAY, epochsBX, epochsBY, epochsAX], method = "mintime")

    print "Epochs After equalising"
    print epochsAX
    print epochsBX
    print epochsAY
    print epochsBY
   
    ###Averaging Epochs#######
    evokedAY =epochsAY.average(picks = picks)
    evokedBX =epochsBX.average(picks = picks)
    evokedBY =epochsBY.average(picks = picks)
    evokedAX =epochsAX.average(picks = picks)
    for ep in [evokedAY, evokedBX, evokedBY, evokedAX]:
           evokeds.append(ep)

    fiff.write_evoked(data_path + 'ave_projon/'+args.subj+'_'+expName+evRun+'-equalisedTar-ave.fif',evokeds)
    evokedRuns.append(evokeds)

##
####################################
############Make grand-average######
runData = []
runNave = []
newEvoked = copy.deepcopy(evokedRuns[0])
#print newEvoked
count = 0
numCond = len(newEvoked)

for c in range(numCond):
    for evRun in evokedRuns:
        runData.append(evRun[c].data)
        runNave.append(evRun[c].nave)
    gaveData = numpy.mean(runData,0)
    gaveNave = numpy.sum(runNave)
    newEvoked[c].data = gaveData
    newEvoked[c].nave = gaveNave
    runData = []
    runNave = []

#Write grand-average to disk
fiff.write_evoked(data_path+'ave_projon/'+args.subj+'_'+expName+'-equalisedTar_All-ave.fif',newEvoked)

