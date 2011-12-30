import mne
from mne import fiff
import pylab as pl
import numpy as np
import argparse
import readInput


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

ymin,ymax = [7,-7]
xmin,xmax = [-100,600]


data_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/ga_fif/'
results_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/EEG_regions/'
channel_path = '/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/eeg_'
channelGroups = ['ant','post']

hemList = ['left','right']

for group in channelGroups:
	pl.clf()

	for hem in hemList:
	
		channelFile = channel_path + hem + '_' + group+ '.txt'
		channelList = readInput.readList(channelFile)
	
		if hem == 'left':
			pl.subplot(121)
		else:
			pl.subplot(122)
		for c in range(2):

			file = data_path + prefixList[c] +'-ave.fif'
			print file
			print 'set ',condList[c]
			evoked = fiff.Evoked(file,setno=condList[c],baseline=(-100,0),proj=False)
			times=evoked.times*1000
			sel = fiff.pick_types(evoked.info,meg=False,eeg=False,include=channelList)
			print sel
			data = evoked.data[sel]*1e6
			region_mean = np.mean(data,0)
			pl.plot(times,region_mean,color=colorList[c])
			pl.ylim([ymin,ymax])
			pl.xlim([xmin,xmax])
		pl.legend((args.label1,args.label2),loc="bottom left")
		pl.title(hem + group)
		pl.plot(times,region_mean*0,color='k')
		pl.show()

	outFile = results_path + args.prefix1 + '-' + args.prefix2 + '-' + str(args.set1)+'-'+str(args.set2)+'-'+group +'.png'
	pl.savefig(outFile)
















