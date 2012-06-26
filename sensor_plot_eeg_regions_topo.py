import mne
from mne import fiff
import pylab as pl
import numpy as np
import argparse
import readInput
import matplotlib

#This script creates quadrant plots for ERP, 12 electrodes go into each region. You can plot two conditions at a time.
#It outputs one single .png file with both anterior (with left and right subplots) and posterior plots. 
#It also outputs a .png file containing the axis figure in classic ERP fashion

#Ex: run sensor_plot_eeg_regions_topo.py ga_ya.n22.meeg_BaleenLP_All_eeg ga_ya.n22.meeg_BaleenLP_All_eeg 0 1 related unrelated


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

eegymin,eegymax = [10,-10]   
eegxmin,eegxmax = [-100,601]
vertScaleBar = 2 #This controls the size of the vertical axis scale (in microV)
lWidth = 2


data_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/ga_fif/'
results_path = '/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/EEG_regions/'
channel_path = '/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/eeg_'

channelGroups = ['ant','post']
hemList = ['left','right']

pl.clf()
for group in channelGroups:
	
	font = {
         'weight' : 'bold',
         'size'   : 16}
	pl.rc('font', **font)
	#figure(num=None, figsize=(16, 6), dpi=80, facecolor='w', edgecolor='k') # you could use this to change the size of the figure

	for hem in hemList:
	
		channelFile = channel_path + hem + '_' + group+ '.txt'
		channelList = readInput.readList(channelFile)
	    
		if hem == 'left':
		    if group == 'ant':
		       pl.subplot(2,2,1)
		       pl.title("Left Anterior")
		    else:
		       pl.subplot(2,2,3)
		       pl.title("Left Posterior")
		else:
		    if group == 'ant':
		       pl.subplot(2,2,2)
		       pl.title("Right Anterior")
		    else:
		       pl.subplot(2,2,4)
		       pl.title("Right Posterior")
		            
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
			
			pl.ylim([eegymin,eegymax]) #set the y limits
			pl.xlim([eegxmin,eegxmax]) #set the x limits
			pl.box('off') # turn off the box frame 
			pl.axhline(y=0,xmin=0,xmax=1,color='k',linewidth=2) #draw a thicker horizontal line at 0
			yfactor = abs(eegymax)+abs(eegymin)
			pl.axvline(x=0,ymin=(.5-(vertScaleBar/float(yfactor))),ymax=(.5+(vertScaleBar/float(yfactor))),color='k',linewidth=2) #draw a vertical line at 0 that goes 1/8 of the range in each direction from the middle (e.g., if the range is -8:8, =16, 1/8 of 16=2, so -2:2).

			pl.yticks(np.array([])) #turn off the y tick labels
			pl.xticks(np.array([])) #turn off the x tick labels		
			pl.tick_params(axis='both',right='off',left='off',bottom='off',top='off') #turn off all the tick marks
			
			#draw vertical lines every hundred ms
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

outFile = results_path + args.prefix1 + '-' + args.prefix2 + '-' + str(args.set1)+'-'+str(args.set2)+'_topo'+ '.png'
pl.savefig(outFile)

##make a plot with the 'key' to the axes, in typical ERP convention

pl.clf()
pl.subplot(121)
pl.ylim([eegymin,eegymax])
pl.xlim([eegxmin,eegxmax])
pl.axvline(x=0,ymin=(.5-(vertScaleBar/float(yfactor))),ymax=(.5+(vertScaleBar/float(yfactor))),color='k',linewidth=2)
pl.axhline(y=0,xmin=0,xmax=1,color='k',linewidth=2)
pl.box('off')
pl.yticks(np.array([-vertScaleBar,0.,vertScaleBar]))
#pl.xticks(np.array([]))
pl.tick_params(axis='both',right='off',left='off',bottom='off',top='off')
pl.ylim([eegymin,eegymax])
pl.xlim([eegxmin,eegxmax])
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








