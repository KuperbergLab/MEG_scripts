
import condCodes as cc
import mne
from mne import fiff
from mne.epochs import combine_event_ids
import numpy
import argparse
import copy


#######Get input

parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('subj',type=str)
parser.add_argument('exp',type=str)
args=parser.parse_args()

print args.subj
print args.exp
exp = args.exp


#######Analysis parameters

###Event file suffix (e.g., artifact rejection applied?)
evSuffix = 'Mod.eve'

###Projection and Average Reference 
projVal = True
avgRefVal = False

###Filtering
hp_cutoff = None
lp_cutoff = 20


#######Experiment specific parameters 

###Runs
runs = cc.runDict[exp]
if args.subj == 'ac8' and exp == 'BaleenLP':
    runs = ['Run1','Run3','Run4']
if args.subj == 'ac19' and exp == 'BaleenLP':
    runs = ['Run1','Run2','Run4']
if args.subj == 'sc19' and exp == 'MaskedMM':
    runs = ['Run2']

###EventLabels
labelList = cc.condLabels[exp]
event_id = {}
for row in labelList:
    event_id[row[1]] = int(row[0])
print event_id

###TimeWindow
tmin = -.1
tmax = float(cc.epMax[exp])


########Artifact rejection parameters

###General
gradRej = 2000e-13
magRej = 3000e-15
eegRej = 100e-6
magFlat = 1e-14
gradFlat = 1000e-15

###Subject-specific
if args.subj == "ya31" or args.subj == "sc9":
    magRej = 4000e-15 ##note exception for ya31 and sc9, whose magnetometers were baseline noisy
if args.subj == "ya5" or args.subj == "ya21" or args.subj == "ya18" or args.subj == "ya27" or args.subj == "ya31" or args.subj == "ac33":
    eegRej = 150e-6  ##note because of alpha for ya21
if args.subj == "ya23":
    eegRej = 125e-6
if args.subj == "ya15":
    eegRej = 80e-6
if args.subj == "ya26":
    eegRej = 90e-6
if args.subj == "ac2" or args.subj == "ac7" or args.subj == "sc6": 
    eegRej = 1
if args.subj == "sc17" or args.subj == "sc20":
    eegRej = 250e-6
if args.subj == "sc6" :
    gradRej = 4000e-13
    magRej = 4000e-15



#####################################
########Compute averages for each run

evokedRuns = []
for evRun in runs:

    ###Get Subject and run-specific parameters
    print evRun
    data_path = '/cluster/kuperberg/SemPrMM/MEG/data/'+args.subj+'/'
    event_fname = data_path + 'eve/' + args.subj + '_' + exp+evRun + evSuffix      
    print event_fname
    raw_fname = data_path + args.subj+'_'+ exp +evRun+'_raw.fif'
    raw_ssp_fname = data_path + args.subj+'_'+ exp +evRun+'_ssp_raw.fif'
    avg_log_fname = data_path + 'ave_projon/logs/' +args.subj+ '_'+exp + evRun +'-ave.log'
    

    ###Setup for reading the original raw data and events
    raw = fiff.Raw(raw_fname)
    events = mne.read_events(event_fname)
    raw_skip = raw.first_samp

    ###Correct events for the fact that ssp data has the skip removed, except sc9, ac12, and ac13 for some reason
    if not (args.subj == "sc9") and not (args.subj == 'ac12') and not (args.subj == 'ac13'):
        for row in events:
            row[0] = row[0]-raw_skip

    ###Read SSP raw data
    raw_ssp = fiff.Raw(raw_ssp_fname,preload=True)

    mne.set_log_file(fname = avg_log_fname, overwrite = True)

    ###Filter SSP raw data
    fiff.Raw.filter(raw_ssp,l_freq=hp_cutoff,h_freq=lp_cutoff)

    ###Pick all channels, including stimulus triggers
    picks = []
    for i in range(raw_ssp.info['nchan']):
        picks.append(i)

    ###Read epochs
    epochs = mne.Epochs(raw_ssp, events, event_id, tmin, tmax, picks=picks, baseline=(None, 0),add_eeg_ref=avgRefVal, proj=projVal,reject=dict(eeg=eegRej,mag=magRej,grad=gradRej),flat=dict(mag=magFlat, grad=gradFlat))
    evokeds = [epochs[cond].average(picks=picks) for cond in event_id]

    ###Add the 120 conditions for BaleenHP
    if exp == 'BaleenHP':
        evoked_Rel = evokeds[4]+evokeds[5]
        evoked_Unrel = evokeds[6]+evokeds[7]
        evokeds.append(evoked_Rel)
        evokeds.append(evoked_Unrel)

    fiff.write_evoked(data_path + 'ave_projon/'+args.subj+'_'+exp+evRun+'-ave.fif',evokeds)
    evokedRuns.append(evokeds)




##############################
############Make grand-average
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

#Write grand-average to disk
fiff.write_evoked(data_path+'ave_projon/'+args.subj+'_'+exp+'_All-ave.fif',newEvoked)
