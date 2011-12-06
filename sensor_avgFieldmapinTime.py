import numpy as np
import mne
import argparse

#example
#run sensor_avgFieldmapinTime.py ga_MaskedMM_All_meg-n21-goodC 4 .350 .450


parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('prefix',type=str)
parser.add_argument('set',type=int)
parser.add_argument('time1',type=float)
parser.add_argument('time2',type=float)

args=parser.parse_args()

##script for creating average field map

data_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/ga_fif/'
#data_path = '/cluster/kuperberg/SemPrMM/MEG/data/'


evokedCrop = mne.fiff.read_evoked(data_path+args.prefix+'-ave.fif',setno=args.set)
evokedCrop.crop(tmin=args.time1, tmax=args.time2)
data = evokedCrop.data.mean(axis=1)

evoked = mne.fiff.read_evoked(data_path+args.prefix+'-ave.fif',setno=args.set)
time_idx = np.where((evoked.times >= args.time1) & (evoked.times <= args.time2))[0]
for x in time_idx:
   evoked.data[:,x] = data

evoked.save('/cluster/kuperberg/SemPrMM/MEG/results/field_maps/'+args.prefix+'-'+str(args.set)+'-'+str(args.time1)+'-'+str(args.time2)+'-ave.fif')
#evoked.save(data_path + args.prefix+'-'+str(args.set)+'-'+str(args.time1)+'-'+str(args.time2)+'-ave.fif')

# evoked = mne.fiff.read_evoked('ga_BaleenHP_All_meg-n24-goodC-ave.fif',setno=6)
# time_idx = np.where((evoked.times >= 0.35) & (evoked.times <= 0.450))[0]
# for x in time_idx:
#    evoked.data[:,x] = data
# 
# evoked.save('ga_BaleenHP_All_meg-n24-goodC-350-450-ave.fif')
