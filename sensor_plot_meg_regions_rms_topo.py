import mne
from mne import fiff
import pylab as pl
import numpy as np
import argparse
import readInput
import writeOutput

##This script plots the RMS for gradiometers in selected regions. It excludes bad channels.
##The RMS is computed at the subject level, so all opposite polarity effects on diff channels
##are accounted for.
##Prints all the 8 plots in one figure. 
## Example: run sensor_plot_meg_regions_rms_topo ya BaleenLP_All ya.n24.bal 0 1 

parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('subjType',type=str)
parser.add_argument('protocol',type=str)
parser.add_argument('prefix',type=str)
parser.add_argument('set1',type=int)
parser.add_argument('set2',type=int)
args=parser.parse_args()

condList = [args.set1, args.set2]
print condList
colorList = ['k','r']
lWidth = 1 ##Changes from 2- Thinner traces 

ymin,ymax = [-.5,30]
xmin,xmax = [-100,710]


data_path = '/cluster/kuperberg/SemPrMM/MEG/data/'
results_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/MEG_rms/'
channel_path = '/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/MEG_Chan_Names/grad_'
channelGroups = ['frontal','temporal','parietal','occipital']
##channelGroups = ['occipital']

hemList = ['L', 'R']

###Get subject list
subjFile = '/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/' + args.prefix + '.txt'
subjects = readInput.readList(subjFile)
print subjects
#subjects = ['1', '2','3']
pl.clf()
for group in channelGroups:

	font = {
         'size'   : 10}
	pl.rc('font', **font)
	
	for hem in hemList:
		
		channelFile = channel_path + hem + group+ '.txt'
		channelNames = readInput.readList(channelFile)
		channelList = []
		for item in channelNames:
			channelList.append('MEG ' + item)
		print group
		print channelList
		
		
		if hem == 'L' :
		    if group == 'frontal':
		       pl.subplot(3,4,2)
		       pl.title("Left Frontal", verticalalignment='bottom')
		    elif group == 'temporal':
		       pl.subplot(3,4,5)
		       pl.title("Left Temporal")
		    elif group == 'parietal':
		       pl.subplot(3,4,6)
		       pl.title("Left Parietal")
		    else:
		       pl.subplot(3,4,10)
		       pl.title("Left Occipital")

		else:
		    if group == 'frontal':
		       pl.subplot(3,4,3)
		       pl.title("Right Frontal")
		    elif group == 'temporal':
		       pl.subplot(3,4,8)
		       pl.title("Right Temporal")
		    elif group == 'parietal':
		       pl.subplot(3,4,7)
		       pl.title("Right Parietal")
		    else:
		       pl.subplot(3,4,11)
		       pl.title("Right Occipital")
			
		
		for c in range(2):
			for subj in subjects:
				file = data_path + args.subjType + subj + '/ave_projon/' + args.subjType + subj + '_'+args.protocol +'-ave.fif'
				#print file
				#print 'set ', condList[c]
				evoked = mne.fiff.read_evoked(file,setno=condList[c],baseline=(-100,0))
				badChanSet = set(evoked.info['bads'])  #These two lines remove bad channels
				goodChannelList = list(set(channelList) - badChanSet)
				sel = fiff.pick_types(evoked.info,meg=False,eeg=False,include=goodChannelList)
				data = evoked.data[sel]
				square = np.power(data,2)
				meanSquare = np.mean(square,0)
				rmsSubj = np.power(meanSquare, .5)
				#print rmsSubj[0]
				if subj == subjects[0]:
					rmsAll = rmsSubj
				else:
					rmsAll = np.vstack((rmsAll, rmsSubj))
				
			rmsGA = np.mean(rmsAll,0)		
			
			times=evoked.times*1000			
			pl.plot(times,rmsGA*1e13,color=colorList[c],linewidth=lWidth)
			pl.ylim([ymin,ymax])
			pl.xlim([xmin,xmax])
			pl.box('off') # turn off the box frame 
			pl.axhline(y=0,xmin=0,xmax=1,color='k',linewidth=2) #draw a thicker horizontal line at 0			
			pl.axvline(x=0,ymin=0,ymax=1,color='k',linewidth=2) #draw a vertical line at 0 that goes 1/8 of the range in each direction from the middle (e.g., if the range is -8:8, =16, 1/8 of 16=2, so -2:2).
			pl.tick_params(axis='both',right='off',top='off') #turn off all the tick marks
			pl.yticks(np.array([0.,4., 8., 12., 16., 20.]))
			pl.xticks(np.array([0, 200, 400, 600]))
			#pl.subplots_adjust(bottom=0.2)
			
pl.subplots_adjust(hspace=.5)
outFile = results_path + args.prefix + '-' + args.protocol + '-' + str(args.set1)+'-'+str(args.set2)+'_topo.png'
pl.savefig(outFile)
pl.show
