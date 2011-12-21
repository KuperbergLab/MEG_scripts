import mne
from mne import fiff
import pylab as pl
import numpy as np
import argparse
import readInput


parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('prefix',type=str)
parser.add_argument('set1',type=int)
parser.add_argument('set2',type=int)
args=parser.parse_args()

condList = [args.set1, args.set2]
colorList = ['k','r']
ymin,ymax = [0,13]
xmin,xmax = [-100,600]
scalingFactor = 1e13

data_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/ga_fif/'
results_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/MEG_rms/'
channel_path = '/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/MEG_Chan_Names/chan_'
channelGroups = ['frontal','temporal','parietal','occipital']

hemList = ['L', 'R']

for group in channelGroups:
	pl.clf()

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
			print 'set ',condList[c]
			evoked = mne.fiff.read_evoked(file,setno=condList[c],baseline=(-100,0))
			times=evoked.times*1000
			sel = fiff.pick_types(evoked.info,meg=False,eeg=False,include=channelList)
			print sel
			data = evoked.data[sel]*1e13
			square = np.power(data,2)
			meanSquare = np.mean(square,0)
			rms = np.power(meanSquare,.5)
			pl.plot(times,rms,color=colorList[c])
			pl.ylim([ymin,ymax])
			pl.xlim([xmin,xmax])
		pl.title(hem + group)
		pl.show()

	outFile = results_path + args.prefix + '-' + str(args.set1)+'-'+str(args.set2)+'-'+group +'.png'
	pl.savefig(outFile)
















