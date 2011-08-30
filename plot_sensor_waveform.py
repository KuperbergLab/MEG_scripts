import mne
import numpy as np
import pylab as pl
import argparse

###example call
##run plot_sensor_waveform.py ga_BaleenHP_All_meg-n24-goodC ga_BaleenHP_All_meg-n24-goodC 0 1 348 related unrelated


###Plotting parameters###

xmin,xmax = [-100, 501]
ymin,ymax = [3,-3] ##EEG
#ymin, ymax = [-1,1] ##MEG
lWidth = 4

color1 = 'k'
color2 = 'r'
lineStyle1 = 'solid'
lineStyle2 = 'solid'

scalingFactor = 1e6 #EEG
#scalingFactor = 1e13

####################################

parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('prefix1',type=str)
parser.add_argument('prefix2',type=str)
parser.add_argument('set1',type=int)
parser.add_argument('set2',type=int)
parser.add_argument('sensor',type=int)
parser.add_argument('label1',type=str)
parser.add_argument('label2',type=str)


args=parser.parse_args()

data_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/ga_fif/'

file1 = data_path + args.prefix1 +'-ave.fif'
evoked1 = mne.fiff.read_evoked(file1,setno=args.set1,baseline=(-100,0))
data1=evoked1.data
wave1 = data1[args.sensor][:]*scalingFactor
print args.sensor

times=evoked1.times*1000

file2 = data_path + args.prefix2 + '-ave.fif'
evoked2 = mne.fiff.read_evoked(file2,setno=args.set2,baseline=(-100,0))
data2=evoked2.data
wave2 = data2[args.sensor][:]*scalingFactor

###################

font = {
         'weight' : 'bold',
         'size'   : 16}
 
pl.rc('font', **font)


pl.clf()
pl.plot(times, wave1,color=color1,linewidth=lWidth,linestyle=lineStyle1)
pl.plot(times, wave2,color=color2,linewidth=lWidth,linestyle=lineStyle2)
pl.plot(times,wave1*0,color='k')
pl.legend((args.label1,args.label2),loc="upper left")
pl.ylim([ymin,ymax])
pl.xlim([xmin,xmax])
pl.xlabel('time (ms)')
#pl.ylabel('microVolts')

outFile = 'scratch/'+args.label1+'-'+args.prefix1+'-'+str(args.set1)+'-'+args.label2+'-'+args.prefix2+'-'+str(args.set2)+'-'+str(args.sensor)+'.png'
pl.savefig(outFile)

