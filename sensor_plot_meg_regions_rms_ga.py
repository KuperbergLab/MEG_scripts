import mne
from mne import fiff
import pylab as pl
import numpy as np
import argparse
import readInput

##This script plots the RMS of the *grand-average*. That means the RMS is acting to overcome 
#the negative/positive effect problem at a g-a sensor-level, but if particular subjects have
#opposite gradiometer fields at the same sensor, the RMS in this script does not overcome that

parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('prefix',type=str)
parser.add_argument('set1',type=int)
parser.add_argument('set2',type=int)
args=parser.parse_args()

condList = [args.set1, args.set2]
print condList
colorList = ['k','r']
lWidth = 4

ymin,ymax = [-.5,16]
xmin,xmax = [-100,600]


data_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/ga_fif/'
results_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/MEG_rms/rms_ga/'
channel_path = '/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/MEG_Chan_Names/grad_'
channelGroups = ['frontal','temporal','parietal','occipital']

hemList = ['L', 'R']

for group in channelGroups:
	pl.clf()
	font = {
         'size'   : 30}
	pl.rc('font', **font)
	
	for hem in hemList:
	
		channelFile = channel_path + hem + group+ '.txt'
		channelNames = readInput.readList(channelFile)
		channelList = []
		for item in channelNames:
			channelList.append('MEG ' + item)
		print group
		print channelList
	
		
		if hem == 'L':
			pl.subplot(121)
		else:
			pl.subplot(122)
		for c in range(2):
			file = data_path + args.prefix +'-ave.fif'
			print file
			print 'set ',condList[c]
			evoked = mne.fiff.read_evoked(file,setno=condList[c],baseline=(-100,0))
			times=evoked.times*1000
			sel = fiff.pick_types(evoked.info,meg=False,eeg=False,include=channelList)
			print sel
			data = evoked.data[sel]*1e13
			square = np.power(data,2)
			meanSquare = np.mean(square,0)
			rms = np.power(meanSquare,.5)
			pl.plot(times,rms,color=colorList[c],linewidth=lWidth)
			pl.ylim([ymin,ymax])
			pl.xlim([xmin,xmax])
			pl.box('off') # turn off the box frame 
			pl.axhline(y=0,xmin=0,xmax=1,color='k',linewidth=2) #draw a thicker horizontal line at 0			
			pl.axvline(x=0,ymin=0,ymax=1,color='k',linewidth=2) #draw a vertical line at 0 that goes 1/8 of the range in each direction from the middle (e.g., if the range is -8:8, =16, 1/8 of 16=2, so -2:2).
			pl.tick_params(axis='both',right='off',top='off') #turn off all the tick marks
			pl.yticks(np.array([0.,4., 8., 12., 16.]))
			pl.xticks(np.array([0, 200, 400, 600]))

		#pl.title(hem + group)
		#pl.show()

	outFile = results_path + args.prefix + '-' + str(args.set1)+'-'+str(args.set2)+'-'+group +'.png'
	pl.savefig(outFile)
















