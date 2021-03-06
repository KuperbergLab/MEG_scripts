"""
====================================================
Computing a 1-way t-test on a time-window from the time series of activations in a label
====================================================
The label is not subject-specific but defined from fsaverage brain

"""
# Author: Alexandre Gramfort <gramfort@nmr.mgh.harvard.edu>
#         modified by Ellen Lau
# License: BSD (3-clause)

print __doc__

import mne
import numpy as np
import scipy
import argparse
import readInput
import writeOutput

parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('prefix',type=str)
parser.add_argument('protocol',type=str)
parser.add_argument('label',type=str)
parser.add_argument('hem', type=str)
parser.add_argument('cond1',type=str)
parser.add_argument('cond2',type=str)
parser.add_argument('t1',type=float)
parser.add_argument('t2',type=float)
parser.add_argument('model',type=str)

args=parser.parse_args()
print args.protocol

subjFile = '/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/' + args.prefix + '.txt'
subjects = readInput.readList(subjFile)
print subjects


baseline=100 #ms
data_path = '/cluster/kuperberg/SemPrMM/MEG/results/source_space/ga_stc'
sample1 = int( round( (args.t1+baseline)/1.6667 ) )
sample2 = int( round( (args.t2+baseline)/1.6667 ) )


stcs_fname = ['/cluster/kuperberg/SemPrMM/MEG/data/ya%s/ave_projon/stc/%s/ya%s_%s_c%s-c%sM-%s-%s.stc' % (s, args.protocol, s, args.protocol,args.cond2,args.cond1,args.model,args.hem) for s in subjects]

#label = 'BaleenHP_c1_c2_350-450_cluster0-'+hem
label = args.label+args.hem
label_fname = data_path + '/label/%s.label' % label
print label

#label = 'G_front_inf-Triangul-'+hem
#label = 'G_front_inf-Opercular-'+hem
#label = 'G_front_inf-Orbital-'+hem
#label = 'G_temp_sup-Lateral-'+hem
#label = 'G_temporal_middle-'+hem
#label = 'Pole_temporal-'+hem
#label = 'S_temporal_sup-'+hem
#label = 'G_pariet_inf-Angular-'+hem

#values, times, vertices = mne.label_time_courses(label_fname, stc_fname)

#vtv = [mne.label_time_courses(label_fname, stc_fname) for stc_fname in stcs_fname]

valuesAll = []
for stc_fname in stcs_fname:
	values, times, vertices = mne.label_time_courses(label_fname, stc_fname)
	#print len(values)
	values = np.mean(values,0)
	#print len(values)
	values = values[sample1:sample2]
	values = np.mean(values,0)
	#print values
	valuesAll.append(values)

print "mean",np.mean(valuesAll)
tval,pval = scipy.stats.ttest_1samp(valuesAll,0)
print "t",tval
print "p",pval


