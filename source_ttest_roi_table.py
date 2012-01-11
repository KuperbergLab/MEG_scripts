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

hemList = ['lh','rh']
labelList = ['Pole_temporal']
#labelList = ['G_front_inf-Opercular', 'G_front_inf-Triangul','G_front_inf-Orbital', 'Pole_temporal', 'G_temp_ant-sup-Lateral','G_temp_post-sup-Lateral','S_temporal_ant-sup','S_temporal_post-sup','G_temporal_ant-middle','G_temporal_post-middle','G_temporal_inf','S_temporal_inf','G_pariet_inf-Angular']

baseline=100 #ms
data_path = '/cluster/kuperberg/SemPrMM/MEG/results/source_space/ga_stc'
sample1 = int( round( (args.t1+baseline)/1.6667 ) )
sample2 = int( round( (args.t2+baseline)/1.6667 ) )

dataTable = [('label','hem','tval','pval')]
for label in labelList:
	for hem in hemList:

		stcs_fname = ['/cluster/kuperberg/SemPrMM/MEG/data/ya%s/ave_projon/stc/%s/ya%s_%s_c%s-c%sM-%s-%s.stc' % (s, args.protocol, s, args.protocol,args.cond2,args.cond1,args.model,hem) for s in subjects]
		label_fname = data_path + '/label/%s-%s.label' % (label, hem)
		
		valuesAll = []
		for stc_fname in stcs_fname:
			values, times, vertices = mne.label_time_courses(label_fname, stc_fname)
			values = np.mean(values,0)
			values = values[sample1:sample2]
			values = np.mean(values,0)
			valuesAll.append(values)
		
		tval,pval = scipy.stats.ttest_1samp(valuesAll,0)
		row = (label, hem, str(tval), str(pval))
		dataTable.append(row)
		
print
print
for row in dataTable:					
	for item in row:
		print item,
	print

