import mne
from mne import fiff
import pylab as pl
import numpy as np
import argparse
import readInput
import matplotlib

#This script creates quadrant plots for ERP, 12 electrodes go into each region. You can plot two conditions at a time.
#It outputs one .png file for anterior (with left and right subplots) and one for posterior. 
#It also outputs a .png file containing the axis figure in classic ERP fashion

#Ex: run sensor_plot_eeg_regions.py ga_ya.n22.meeg_BaleenLP_All_eeg ga_ya.n22.meeg_BaleenLP_All_eeg 0 1 related unrelated


parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('prefix1',type=str)
parser.add_argument('prefix2',type=str)
parser.add_argument('set1',type=int)
parser.add_argument('set2',type=int)
parser.add_argument('label1',type=str)
parser.add_argument('label2',type=str)
args=parser.parse_args()

condList = [args.set1, args.set2]
prefixList = [args.prefix1, args.prefix2]
print condList
colorList = ['k','r']

ymin,ymax = [8,-8]
xmin,xmax = [-100,601]
lWidth = 4


data_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/ga_fif/'
results_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/EEG_regions/'
channel_path = '/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/eeg_'

channelGroups = ['ant','post']
hemList = ['left','right']


for group in channelGroups:
	pl.clf()
	font = {
         'weight' : 'bold',
         'size'   : 16}
	pl.rc('font', **font)
	#figure(num=None, figsize=(16, 6), dpi=80, facecolor='w', edgecolor='k') # you could use this to change the size of the figure

	for hem in hemList:
	
		channelFile = channel_path + hem + '_' + group+ '.txt'
		channelList = readInput.readList(channelFile)
	
		if hem == 'left':
			pl.subplot(121)
		else:
			pl.subplot(122)
		for c in range(2):
		
			##get the data
			file = data_path + prefixList[c] +'-ave.fif'
                        ##file = data_path + args.prefix1 +'-ave.fif'
			print file
			print 'set ',condList[c]
			evoked = fiff.Evoked(file,setno=condList[c],baseline=(-100,0),proj=False)
			times=evoked.times*1000
			sel = fiff.pick_types(evoked.info,meg=False,eeg=False,include=channelList)
			print sel
			data = evoked.data[sel]*1e6
			
			##take the mean across the electrodes in this region
			region_mean = np.mean(data,0)
			
			###plotting commands
			pl.plot(times,region_mean,color=colorList[c],linewidth=lWidth) #plot the data
			
			pl.ylim([ymin,ymax]) #set the y limits
			pl.xlim([xmin,xmax]) #set the x limits
			pl.box('off') # turn off the box frame 
			pl.axhline(y=0,xmin=0,xmax=1,color='k',linewidth=2) #draw a thicker horizontal line at 0			
			pl.axvline(x=0,ymin=.375,ymax=.625,color='k',linewidth=2) #draw a vertical line at 0 that goes 1/8 of the range in each direction from the middle (e.g., if the range is -8:8, =16, 1/8 of 16=2, so -2:2).

			pl.yticks(np.array([])) #turn off the y tick labels
			pl.xticks(np.array([])) #turn off the x tick labels		
			pl.tick_params(axis='both',right='off',left='off',bottom='off',top='off') #turn off all the tick marks
			
			#draw horizontal lines every hundred ms
			pl.axvline(x=100,ymin=.48, ymax=.52, color='k',linewidth=2) 
			pl.axvline(x=200,ymin=.48, ymax=.52, color='k',linewidth=2)
			pl.axvline(x=300,ymin=.48, ymax=.52, color='k',linewidth=2)
			pl.axvline(x=400,ymin=.48, ymax=.52, color='k',linewidth=2)
			pl.axvline(x=500,ymin=.48, ymax=.52, color='k',linewidth=2)
			
			#draw little endings to the vertical line at 0, in typical ERP convention
			pl.axhline(y=-2,xmin=.12,xmax=.17, color = 'k',linewidth=2)
			pl.axhline(y=2,xmin=.12,xmax=.17, color = 'k',linewidth=2)

		#pl.legend((args.label1,args.label2),loc="bottom left")
		#pl.title(hem + group)
		pl.plot(times,region_mean*0,color='k')
		pl.show()

	outFile = results_path + args.prefix1 + '-' + args.prefix2 + '-' + str(args.set1)+'-'+str(args.set2)+'-'+group +'.png'
	pl.savefig(outFile)

##make a plot with the 'key' to the axes, in typical ERP convention

pl.clf()
pl.subplot(121)
pl.ylim([8,-8])
pl.xlim([xmin,xmax])
pl.axvline(x=0,ymin=.375,ymax=.625,color='k',linewidth=2)
pl.axhline(y=0,xmin=0,xmax=1,color='k',linewidth=2)
pl.box('off')
pl.yticks(np.array([-2.,0.,2.]))
#pl.xticks(np.array([]))
pl.tick_params(axis='both',right='off',left='off',bottom='off',top='off')
pl.ylim([ymin,ymax])
pl.xlim([xmin,xmax])
pl.axvline(x=100,ymin=.48, ymax=.52, color='k',linewidth=2)
pl.axvline(x=200,ymin=.48, ymax=.52, color='k',linewidth=2)
pl.axvline(x=300,ymin=.48, ymax=.52, color='k',linewidth=2)
pl.axvline(x=400,ymin=.48, ymax=.52, color='k',linewidth=2)
pl.axvline(x=500,ymin=.48, ymax=.52, color='k',linewidth=2)
pl.axhline(y=-2,xmin=.12,xmax=.17, color = 'k',linewidth=2)
pl.axhline(y=2,xmin=.12,xmax=.17, color = 'k',linewidth=2)



pl.show
outFile = results_path + 'axis.png'
pl.savefig(outFile)








