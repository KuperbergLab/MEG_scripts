
import mne
from mne import fiff
from mne.epochs import combine_event_ids
import numpy
import argparse
import copy

parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('subj',type=str)
args=parser.parse_args()

print args.subj
####Experiment specific parameters (needs to be softcoded)

runs = ['Run1','Run2','Run3','Run4']
exp = 'BaleenHP'
tmin = -.1
tmax = .7

gradRej = 2000e-13
magRej = 3000e-15
eegRej = 100e-6
magFlat = 1e-14
gradFlat = 1000e-15

## SUBJECT-SPECIFIC REJECTION THRESHOLD MODIFICATIONS
if args.subj == "ya31" or args.subj == 'sc9':
    magRej = "4000e-15"   ##note exception for ya31 and sc9, whose magnetometers were baseline noisy
 	
if args.subj == "ya5" or args.subj == "ya21" or args.subj == "ya18" or args.subj == "ya27" or args.subj == "ya31":
    eegRej = "150e-6"   ##because of alpha for ya21
 	
if args.subj == "ya23":
    eegRej = "125e-6"
 
if args.subj == "ya15":
    eegRej = "80e-6"
				
if args.subj == "ya26":
    eegRej = "90e-6"

if args.subj == "ac2" or args.subj == "ac7" or args.subj == "sc19": 
    eegRej = "1"
		
if args.subj == "sc17" or args.subj == "sc20":
    eegRej = "250e-6"

evokedRuns = []
for evRun in runs:
    ####Subject and run-specific parameters

    data_path = '/cluster/kuperberg/SemPrMM/MEG/data/'+args.subj+'/'
    raw_fname = data_path + args.subj+'_'+ exp +evRun+'_raw.fif'
    raw_ssp_fname = data_path + args.subj+'_'+ exp +evRun+'_ssp_raw.fif'
    event_fname = data_path + 'eve/'+args.subj+'_'+exp+evRun+'Mod.eve'
    event_id = dict(Related=6, Unrelated=7, RelatedFiller=8, UnrelatedFiller=9, ProbeTarget=10, ProbePrime=12, Prime=14, RelatedFillerExtra=18)
    print event_fname

    #   Setup for reading the original raw data and events
    raw = fiff.Raw(raw_fname)
    events = mne.read_events(event_fname)
    raw_skip = raw.first_samp

    #   Correct events for the fact that ssp data has the skip removed
    for row in events:
        row[0] = row[0]-raw_skip

    #   Read SSP raw data
    raw_ssp = fiff.Raw(raw_ssp_fname,preload=True)

    #   Filter SSP raw data
    fiff.Raw.filter(raw_ssp,l_freq=None,h_freq=20)

    #   Set up pick list
    include = []  # or stim channels ['STI 014']
    exclude = []
    #exclude = raw.info['bads'] # bads

    # pick all channels
    #picks = fiff.pick_types(raw_ssp.info, meg=True, eeg=True, stim=True, eog=True, include=include, exclude=exclude)
    picks = []
    for i in range(raw_ssp.info['nchan']):
        picks.append(i)

    # Read epochs
    epochs = mne.Epochs(raw_ssp, events, event_id, tmin, tmax, picks=picks, baseline=(None, 0),add_eeg_ref=False, proj=True,reject=dict(eeg=eegRej,mag=magRej,grad=gradRej),flat=dict(mag=magFlat, grad=gradFlat))

    #Combine conditions
    combine_event_ids(epochs, ['Related', 'RelatedFiller'],{'Related120':68},copy=False)
    combine_event_ids(epochs, ['Unrelated','UnrelatedFiller'],{'Unrelated120':79},copy=False)


    evokeds = [epochs[cond].average(picks=picks) for cond in event_id]
    fiff.write_evoked(data_path + 'ave_projon/'+args.subj+'_'+exp+evRun+'-ave.fif',evokeds)
    
    evokedRuns.append(evokeds)


#Make grand-average
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
fiff.write_evoked(data_path+'ave_projon/'+args.subj+'_'+exp+'_All_noavgref-ave.fif',newEvoked)
