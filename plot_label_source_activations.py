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

hem = 'lh'
exp = 'HP'

data_path = '/cluster/kuperberg/SemPrMM/MEG/results/source_space/ga_stc'
stc_fname = data_path + '/diff/ga_Baleen'+exp+'_All_c2-c1M_n24-spm-'+hem+'.stc'

#label = 'BaleenHP_c1_c2_350-450_cluster0-'+hem
label = 'S_temporal_sup-'+hem
label_fname = data_path + '/label/%s.label' % label

#label = 'G_front_inf-Triangul-'+hem
#label = 'G_front_inf-Opercular-'+hem
#label = 'G_front_inf-Orbital-'+hem
#label = 'G_temp_sup-Lateral-'+hem
#label = 'G_temporal_middle-'+hem
#label = 'Pole_temporal-'+hem
#label = 'S_temporal_sup-'+hem
#label = 'G_pariet_inf-Angular-'+hem


values, times, vertices = mne.label_time_courses(label_fname, stc_fname)

print values.shape
values = np.mean(values,0)
print values.shape

print "Number of vertices : %d" % len(vertices)

# View source activations
import pylab as pl
pl.plot([None], [None])
if exp == 'LP':
	pl.plot(times, values.T,color='b',linewidth=4)
if exp == 'HP':
	pl.plot(times, values.T,color='b',linewidth=4,linestyle='dotted')
	pl.legend(('low-proportion','high-proportion'))
pl.plot(times,values.T*0,color='k')
pl.ylim([-1,1])
pl.xlim([-.1,.51])
pl.xlabel('time (ms)')
pl.ylabel('Source amplitude')
pl.title('Activations in Label : %s' % label)

pl.show()
