"""
====================================================
Extracting the time series of activations in a label
====================================================


"""
# Author: Alexandre Gramfort <gramfort@nmr.mgh.harvard.edu>
#
# License: BSD (3-clause)

print __doc__

import mne
#from mne.datasets import sample

import numpy as np

data_path = '/cluster/kuperberg/SemPrMM/MEG/results/source_space/ga_stc'
stc_fname = data_path + '/diff/ga_BaleenLP_All_c2-c1M_n24-spm-lh.stc'
label = 'BaleenHP_c1_c2_350-450_cluster1-lh'
label_fname = data_path + '/label/%s.label' % label

values, times, vertices = mne.label_time_courses(label_fname, stc_fname)

print values.shape
values = np.mean(values,0)
print values.shape

print "Number of vertices : %d" % len(vertices)

# View source activations
import pylab as pl
pl.plot(times, values.T)
pl.xlabel('time (ms)')
pl.ylabel('Source amplitude')
pl.title('Activations in Label : %s' % label)
pl.show()
