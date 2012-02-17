#usage: python maxFilter.py ya1

import sys
import os
import readInput



def maxFilter(subjID):

	##constants
	corrThresh = .96
	sampleTime = 30
	
	expList = ['BaleenHP']
	
	runDict = {'BaleenHP':['Run1','Run2','Run3','Run4']}
	
	dataPath = "/cluster/kuperberg/SemPrMM/MEG/data/" + subjID + "/"
	badChanFileName = dataPath + subjID + "_bad_chan.txt"
	badChanList = readInput.readList(badChanFileName)
	print badChanList
	
	badMEG = ''
	for chan in badChanList:
		if chan[0:3] == 'MEG':
			print chan[-4:]
			badMEG = badMEG + (chan[-4:]) + ' '
	
	for exp in expList:
		for run in runDict[exp]:
			in_fif_fname = dataPath + subjID + '_' + exp + run + '_raw.fif'
			out_fif_fname = dataPath + subjID + '_' + exp + run + '_MF_raw.fif'
	
			command = ('maxfilter -f %s -v -frame head -st %s -corr %s -origin 0 0 40 -bad %s -o %s -force'
                   % (in_fif_fname, sampleTime, corrThresh, badMEG, out_fif_fname))
	
			print command
			st = os.system(command)
			print 'Command executed: %s' % command
			if st != 0:
				raise ValueError('Pb while running : %s' % command)
			else: 
				print ('Done removing ECG and EOG artifacts. IMPORTANT : Please eye-ball the data !!')
 

if __name__ == "__main__":
	maxFilter(sys.argv[1])