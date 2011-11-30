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
import numpy as np
import pylab as pl
import argparse

####Plotting Parameters####
xmin,xmax = [-100, 701]
ymin,ymax = [-.5, 2]
lWidth = 4

color1 = 'r'
color2 = 'g'
lineStyle1 = 'solid'
lineStyle2 = 'solid'
lineLabel1 = 'LP left'
lineLabel2 = 'LP right'


####################################

parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('protocol1',type=str)
parser.add_argument('protocol2',type=str)
parser.add_argument('label1',type=str)
parser.add_argument('label2',type=str)
parser.add_argument('hem1',type=str)
parser.add_argument('hem2',type=str)
parser.add_argument('set1',type=str)
parser.add_argument('set2',type=str)

args=parser.parse_args()

data_path = '/cluster/kuperberg/SemPrMM/MEG/results/source_space/ga_stc'
stc1_fname = data_path + '/diff/Baleen/ga_'+args.protocol1+'_All_c'+args.set2+'-c'+args.set1+'M_n24-spm-'+args.hem1+'.stc'
stc2_fname = data_path + '/diff/Baleen/ga_'+args.protocol2+'_All_c'+args.set2+'-c'+args.set1+'M_n24-spm-'+args.hem2+'.stc'
#stc1_fname = data_path + '/single_condition/ga_'+args.protocol1+'_All_c'+args.set1+'M_n24-spm-'+args.hem1+'.stc'
#stc2_fname = data_path + '/single_condition/ga_'+args.protocol2+'_All_c'+args.set2+'M_n24-spm-'+args.hem2+'.stc'
#stc1_fname = data_path + '/single_condition/ga_'+args.protocol1+'_AllUnrelated_c'+args.set1+'M_n24-spm-'+args.hem1+'.stc'
#stc2_fname = data_path + '/single_condition/ga_'+args.protocol2+'_AllUnrelated_c'+args.set2+'M_n24-spm-'+args.hem2+'.stc'


label1 = args.label1+'-'+args.hem1
label2 = args.label2+'-'+args.hem2
label1_fname = data_path + '/label/%s.label' % label1
label2_fname = data_path + '/label/%s.label' % label2


values1, times1, vertices1 = mne.label_time_courses(label1_fname, stc1_fname)
values1 = np.mean(values1,0)
#print values1.shape
print "Number of vertices : %d" % len(vertices1)

values2, times2, vertices2 = mne.label_time_courses(label2_fname, stc2_fname)
values2 = np.mean(values2,0)
print "Number of vertices : %d" % len(vertices1)

times1=times1*1000
times2=times2*1000

font = {'family' : 'normal',
        'weight' : 'bold',
        'size'   : 16}

pl.rc('font', **font)

#########################
# View source activations

pl.clf()
pl.plot(times1, values1.T,color=color1,linewidth=lWidth,linestyle=lineStyle1)
pl.plot(times2, values2.T,color=color2,linewidth=lWidth,linestyle=lineStyle2)
pl.plot(times1,values1.T*0,color='k')
#pl.legend((lineLabel1,lineLabel2),loc="upper left")
pl.ylim([ymin,ymax])
pl.xlim([xmin,xmax])
pl.xlabel('time (ms)')
pl.ylabel('Source amplitude')
#pl.title('Activations in Label : %s' % label1)
#pl.ticklabel_format(style='plain',axis='x')
#pl.rcParams.update({'font.size': 12})
pl.show()
outFile = 'scratch/'+args.label1+'-'+args.hem2+'-'+args.protocol1+'-'+args.label2+'-'+args.hem2+'-'+args.protocol2+'.png'
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

