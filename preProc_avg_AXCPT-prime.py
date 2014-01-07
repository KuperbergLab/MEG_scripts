
import condCodes as cc
import mne
from mne import fiff
from mne.epochs import combine_event_ids
import numpy
import argparse
import copy
from mne.epochs import equalize_epoch_counts


############################################
#######Get input###########

parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('subj',type=str)
#parser.add_argument('exp',type=str)
args=parser.parse_args()

print args.subj
#print args.exp
#exp = args.exp
exp = 'AXCPTpri'
print exp
expName = 'AXCPT'

######################################
#######Analysis parameters###########

###Event file suffix (e.g., artifact rejection applied?)
evSuffix = 'ModRej.eve' ##Change back to ModRej.eve - testing ssp on AXCPT data - CU 12/26/13 
#evSuffix = '_raw-eve.fif'


###Projection and Average Reference 
projVal = True
avgRefVal = False

###Filtering
hp_cutoff = None
lp_cutoff = 20


############################################
#######Experiment specific parameters####### 
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
########Artifact rejection parameters#######

###General#######
gradRej = 2000e-13
magRej = 3000e-15
eegRej = 100e-6
magFlat = 1e-14
gradFlat = 1000e-15

###Subject-specific#######
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


############################################
########Compute averages for each run#######

event_id = {'APrime': 5, 'BPrime': 6}
evokedRuns = []
epochs_eq = []
evokeds = []
ep =[]
for evRun in runs:
    evokeds = []

    ###Get Subject and run-specific parameters#######
    print evRun
    data_path = '/cluster/kuperberg/SemPrMM/MEG/data/'+args.subj+'/'
    event_fname = data_path + 'eve/' + args.subj + '_' + expName+evRun + evSuffix
    #event_fname = data_path  + args.subj + '_' + expName+evRun + evSuffix      
    print event_fname
    raw_fname = data_path + args.subj+'_'+ expName +evRun+'_ssp_raw.fif' ##Using ssp because for only for ya12, ya27, ya31 AXCPT- ecg SSP has been perfrmed, rest have been sym-linked to the raw file. 
    #raw_ssp_fname = data_path + args.subj+'_'+ expName +evRun+'_raw.fif' ## _ssp_raw.fif
    avg_log_fname = data_path + 'ave_projon/logs/' +args.subj+ '_'+expName + evRun +'-equalisePri-test-ave.log' ##CHANGE THIS
    

    ###Setup for reading the original raw data and events#######
    raw = fiff.Raw(raw_fname, preload=True)
    events = mne.read_events(event_fname)
    raw_skip = raw.first_samp

    ###Correct events for the fact that ssp data has the skip removed
    if (args.subj == "ya12") or (args.subj == 'ya27') or (args.subj == 'ya31'): #############################Change back 0-- testing with ssp for all subjects CU 12/26/13
        print "Adjusting events for SSP raw.fif files"
        for row in events:
            row[0] = row[0]-raw_skip

    mne.set_log_file(fname = avg_log_fname, overwrite = True)

    ###Filter SSP raw data#######
    fiff.Raw.filter(raw,l_freq=hp_cutoff,h_freq=lp_cutoff)

    ###Pick all channels, including stimulus triggers#######
    picks = []
    for i in range(raw.info['nchan']):
        picks.append(i)

    ###Read Prime Epochs#######
    ###Include catch for subjects where ssp-ecg was performed###
    epochsAPrime = mne.Epochs(raw, events, event_id['APrime'], tmin, tmax , name = 'APrime', picks=picks, baseline=(None, 0),add_eeg_ref=avgRefVal, proj=projVal,reject=dict(eeg=eegRej,mag=magRej,grad=gradRej),flat=dict(mag=magFlat, grad=gradFlat))
    epochsBPrime = mne.Epochs(raw, events, event_id['BPrime'], tmin, tmax , name = 'BPrime', picks=picks, baseline=(None, 0),add_eeg_ref=avgRefVal, proj=projVal,reject=dict(eeg=eegRej,mag=magRej,grad=gradRej),flat=dict(mag=magFlat, grad=gradFlat))
                   
    print "Epochs before equalising"
    print epochsAPrime
    print epochsBPrime

    ###Equalising A and B Prime trials for AXCPT - YA#######
    mne.epochs.equalize_epoch_counts([epochsAPrime, epochsBPrime], method ="mintime")

    print "Epochs after equalising"
    print epochsAPrime
    print epochsBPrime
 
    ###Averaging Epochs#######
    evokedAPrime =epochsAPrime.average(picks = picks)
    evokedBPrime =epochsBPrime.average(picks = picks)
    for ep in [evokedAPrime, evokedBPrime]:
           evokeds.append(ep)
        
    ###Computing Evoked Potentials#######
    fiff.write_evoked(data_path + 'ave_projon/'+args.subj+'_'+expName+evRun+'-equalisedPri-ave.fif',evokeds)
    evokedRuns.append(evokeds)


#######################################
##########Make grand-average###########
runData = []
runNave = []
newEvoked = copy.deepcopy(evokedRuns[0])
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

#######Write grand-average to disk####
fiff.write_evoked(data_path+'ave_projon/'+args.subj+'_'+expName+'-equalisedPri_All-ave.fif',newEvoked)


