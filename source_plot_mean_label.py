"""
====================================================
Extracting the mean time series of activations in a label
====================================================


"""
# Author: Alexandre Gramfort <gramfort@nmr.mgh.harvard.edu>
# Edited by Ellen Lau <ellenlau@nmr.mgh.harvard.edu>
# License: BSD (3-clause)

print __doc__

import mne
from mne import fiff
import numpy as np
import pylab as pl
import argparse

####Plotting Parameters####
xmin,xmax = [-100, 710]
ymin,ymax = [0, 10]
lWidth = 4

color1 = 'k'
color2 = 'r'
lineStyle1 = 'solid'
lineStyle2 = 'solid'
lineLabel1 = 'dir related'
lineLabel2 = 'unrelated'


####################################

parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('prefix',type=str)
parser.add_argument('protocol1',type=str)
parser.add_argument('protocol2',type=str)
parser.add_argument('label1',type=str)
parser.add_argument('hem1',type=str)
parser.add_argument('hem2',type=str)
parser.add_argument('set1',type=str)
parser.add_argument('set2',type=str)
parser.add_argument('model',type=str)
parser.add_argument('single_diff',type=str)

args=parser.parse_args()

data_path = '/cluster/kuperberg/SemPrMM/MEG/results/source_space/ga_stc'

if args.single_diff == 'diff':
	stc1_fname = data_path + '/diff/ga_'+args.prefix+'_'+args.protocol1+'_c'+args.set2+'-c'+args.set1+'M-'+args.model+'-'+args.hem1+'.stc'
	stc2_fname = data_path + '/diff/ga_'+args.prefix+'_'+args.protocol2+'_c'+args.set2+'-c'+args.set1+'M-'+args.model+'-'+args.hem2+'.stc'
else:
	stc1_fname = data_path + '/single_condition/ga_'+args.prefix+'_'+args.protocol1+'_c'+args.set1+'M-'+args.model+'-'+args.hem1+'.stc'
	stc2_fname = data_path + '/single_condition/ga_'+args.prefix+'_'+args.protocol2+'_c'+args.set2+'M-'+args.model+'-'+args.hem2+'.stc'




label1 = args.label1+'-'+args.hem1

label1_fname = data_path + '/label/%s.label' % label1


values1, times1, vertices1 = mne.label_time_courses(label1_fname, stc1_fname)
values1 = np.mean(values1,0)
#print values1.shape
print "Number of vertices : %d" % len(vertices1)

values2, times2, vertices2 = mne.label_time_courses(label1_fname, stc2_fname)
values2 = np.mean(values2,0)
print "Number of vertices : %d" % len(vertices1)

times1=times1*1000
times2=times2*1000

#        'weight' : 'bold',
font = {'family' : 'normal',
        'size'   : 30}

pl.rc('font', **font)

#########################
# View source activations

pl.clf()
pl.plot(times1, values1.T,color=color1,linewidth=lWidth,linestyle=lineStyle1)
pl.plot(times2, values2.T,color=color2,linewidth=lWidth,linestyle=lineStyle2)
pl.plot(times1,values1.T*0,color='k')
#pl.legend((lineLabel1,lineLabel2),loc="upper left")
pl.axvline(x=0,ymin=0,ymax=1,color='k')
pl.ylim([ymin,ymax])
pl.xlim([xmin,xmax])
pl.box('off') # turn off the box frame 
pl.axhline(y=0,xmin=0,xmax=1,color='k',linewidth=2) #draw a thicker horizontal line at 0			
pl.axvline(x=0,ymin=0,ymax=1,color='k',linewidth=2) #draw a vertical line at 0 that goes 1/8 of the range in each direction from the middle (e.g., if the range is -8:8, =16, 1/8 of 16=2, so -2:2).
pl.tick_params(axis='both',right='off',top='off') #turn off all the tick marks
pl.yticks(np.array([0.,2., 4.,6.,8.]))
pl.xticks(np.array([0, 200, 400, 600]))

#pl.xlabel('time (ms)')
#pl.ylabel('Source amplitude')
pl.axvspan(300, 500, color='k', alpha=0.1)
#pl.title('Activations in Label : %s' % label1)
#pl.ticklabel_format(style='plain',axis='x')
#pl.rcParams.update({'font.size': 12})
pl.show()
outFile = data_path + '/roi_plots/'+args.label1+'-'+args.hem2+'-'+args.protocol1+'-'+args.hem2+'-'+args.protocol2+'-'+args.set1+'-'+args.set2 + '-'+ args.single_diff + '-' +args.model+'.png'
pl.savefig(outFile)


#label = 'BaleenHP_c1_c2_350-450_cluster0-'+hem
#label = 'G_front_inf-Triangul-'+hem
#label = 'G_front_inf-Opercular-'+hem
#label = 'G_front_inf-Orbital-'+hem
#label = 'G_temp_sup-Lateral-'+hem
#label = 'G_temporal_middle-'+hem
#label = 'Pole_temporal-'+hem
#label = 'S_temporal_sup-'+hem
#label = 'G_pariet_inf-Angular-'+hem

