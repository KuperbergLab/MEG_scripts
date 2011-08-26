import numpy as np
import mne

##script for creating average field map

evokedCrop = mne.fiff.read_evoked('ga_BaleenLP_All_meg-n24-goodC-ave.fif',setno=4)
evokedCrop.crop(tmin=0.35, tmax=0.45)
data = evokedCrop.data.mean(axis=1)

evoked = mne.fiff.read_evoked('ga_BaleenLP_All_meg-n24-goodC-ave.fif',setno=4)
time_idx = np.where((evoked.times >= 0.35) & (evoked.times <= 0.450))[0]
for x in time_idx:
   evoked.data[:,x] = data

evoked.save('ga_BaleenLP_All_meg-n24-goodC-350-450-ave.fif')


import numpy as np
import mne

evokedCrop = mne.fiff.read_evoked('ga_BaleenHP_All_meg-n24-goodC-ave.fif',setno=6)
evokedCrop.crop(tmin=0.35, tmax=0.45)
data = evokedCrop.data.mean(axis=1)

evoked = mne.fiff.read_evoked('ga_BaleenHP_All_meg-n24-goodC-ave.fif',setno=6)
time_idx = np.where((evoked.times >= 0.35) & (evoked.times <= 0.450))[0]
for x in time_idx:
   evoked.data[:,x] = data

evoked.save('ga_BaleenHP_All_meg-n24-goodC-350-450-ave.fif')
