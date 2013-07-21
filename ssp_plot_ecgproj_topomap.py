# Author: Alexandre Gramfort <gramfort@nmr.mgh.harvard.edu>
#
# License: BSD (3-clause)



print __doc__

import pylab as pl
import mne
import sys
subjID = sys.argv[1]
#listPrefix = sys.argv[2]
study = sys.argv[2]

#from mne.datasets import sample
data_path = '/cluster/kuperberg/SemPrMM/MEG/data/' + subjID
ecg_fname = data_path + '/ssp/' + subjID +'_'+study+'Run1_eog_proj.fif'
#print ecg_fname 
ave_fname = data_path + '/ave_projon/' + subjID +'_'+study+'Run1-ave.fif' 

evoked = mne.fiff.read_evoked(ave_fname, setno='Related')
projs = mne.read_proj(ecg_fname)
#lay = mne.layouts.read_layout('/autofs/homes/001/candida/.mne/lout/std2_70elec.lout')
#print lay

layouts = [mne.layouts.read_layout('Vectorview-all'),
          mne.layouts.read_layout('/autofs/homes/001/candida/.mne/lout/std2_70elec.lout')]

pl.figure(figsize=(10, 6))
mne.viz.plot_projs_topomap(projs, layout=layouts)
mne.viz.tight_layout()
