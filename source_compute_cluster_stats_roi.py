"""
=======================================================
Permutation F-test on ROI timecourse data with 1D cluster level
=======================================================

One tests if the ROI timecourse is significantly different
between conditions. Multiple comparison problem is adressed
with cluster level permutation test.

"""

# Authors: Alexandre Gramfort <gramfort@nmr.mgh.harvard.edu>
# Modified by Ellen Lau
#
# License: BSD (3-clause)

#run source_compute_cluster_stats_roi.py ya.n22.meeg BaleenHP_All BaleenHP_All Pole_temporal- lh 1 2 spm


print __doc__

import mne
from mne import fiff
from mne.stats import permutation_cluster_test
from mne.datasets import sample
import argparse
import readInput
import numpy as np


###############################################################################
# Set parameters

parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('prefix',type=str)
parser.add_argument('protocol1',type=str)
parser.add_argument('protocol2',type=str)
parser.add_argument('label',type=str)
parser.add_argument('hem', type=str)
parser.add_argument('cond1',type=str)
parser.add_argument('cond2',type=str)
parser.add_argument('model',type=str)

args=parser.parse_args()
print args.protocol1

data_path = '/cluster/kuperberg/SemPrMM/MEG/results/source_space/ga_stc'
figure_path = '/cluster/kuperberg/SemPrMM/MEG/results/source_space/roi_temporal_clustering_figures/'

subjFile = '/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/' + args.prefix + '.txt'
subjects = readInput.readList(subjFile)
print subjects

stcs1_fname = ['/cluster/kuperberg/SemPrMM/MEG/data/ya%s/ave_projon/stc/%s/ya%s_%s_c%sM-%s-%s.stc' % (s, args.protocol1, s, args.protocol1,args.cond1,args.model,args.hem) for s in subjects]
stcs2_fname = ['/cluster/kuperberg/SemPrMM/MEG/data/ya%s/ave_projon/stc/%s/ya%s_%s_c%sM-%s-%s.stc' % (s, args.protocol2, s, args.protocol2,args.cond2,args.model,args.hem) for s in subjects]

label = args.label+args.hem
label_fname = data_path + '/label/%s.label' % label
print label

baseline = 100 #ms
#sample1 = int(round( (baseline)/1.6667)) #don't predict any differences in baseline or first 100
#print sample1
sample1 = 0

valuesAll1 = []
for stc_fname in stcs1_fname:
	values, times, vertices = mne.label_time_courses(label_fname, stc_fname)
	values = np.mean(values,0)
	values = values[sample1:]
	valuesAll1.append(values)
condition1 = np.array(valuesAll1)
print len(valuesAll1)

valuesAll2 = []
for stc_fname in stcs2_fname:
	values, times, vertices = mne.label_time_courses(label_fname, stc_fname)
	values = np.mean(values,0)
	values = values[sample1:]
	valuesAll2.append(values)
condition2 = np.array(valuesAll2)
print len(valuesAll2)

times = times[sample1:]


###############################################################################
# Compute statistic
threshold = 2.07 #2.8
print threshold
T_obs, clusters, cluster_p_values, H0 = \
                 permutation_cluster_test([condition1, condition2],
                             n_permutations=1000, threshold=threshold, tail=1,
                             n_jobs=2)

###############################################################################
# Plot
import pylab as pl

xmin,xmax = [-100, 701]
ymin,ymax = [0, 4]
if args.model == 'mne':
	ymin,ymax = [0,4*1e-10]
lWidth = 4
color1 = 'k'
color2 = 'r'
lineStyle1 = 'solid'
lineStyle2 = 'solid'
lineLabel1 = 'LP left'
lineLabel2 = 'LP right'

font = {'weight' : 'bold',
        'size'   : 16}

pl.rc('font', **font)

pl.close('all')
pl.subplot(211)
#pl.title('ROI : ' + label)
pl.plot(times*1000, condition1.mean(axis=0),color=color1,linewidth=lWidth,linestyle=lineStyle1)
pl.plot(times*1000, condition2.mean(axis=0),color=color2,linewidth=lWidth,linestyle=lineStyle2)
pl.ylim([ymin,ymax])
pl.xlabel("time (ms)")

#pl.plot(times, condition2.mean(axis=0) - condition1.mean(axis=0), label="ERF Contrast (Event 2 - Event 1)")
# pl.ylabel("MEG (T / m)")
pl.legend()
pl.subplot(212)
for i_c, c in enumerate(clusters):
    c = c[0]
    if cluster_p_values[i_c] <= 0.05:
        h = pl.axvspan(times[c.start]*1000, times[c.stop - 1]*1000, color='r', alpha=0.3)
        print 'sig:', times[c.start], times[c.stop -1], 'p:', cluster_p_values[i_c]
    else:
        #pl.axvspan(times[c.start], times[c.stop - 1], color=(0.3, 0.3, 0.3), alpha=0.3)
        print 'non-sig:', times[c.start], times[c.stop -1], 'p:',cluster_p_values[i_c]
hf = pl.plot(times*1000, T_obs, 'g')

ymin,ymax = [0, 14]

pl.ylim([ymin,ymax])


#pl.legend((h, ), ('cluster p-value < 0.05', ))
pl.xlabel("time (ms)")
# pl.ylabel("f-values")
pl.show()

outFile = figure_path+args.prefix + '-' + args.label+args.hem+'-'+args.protocol1+args.cond1+'-'+args.protocol2+args.cond2+'.png'
pl.savefig(outFile,dpi = (200))
