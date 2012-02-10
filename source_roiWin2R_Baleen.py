"""
====================================================
For Baleen, outputting data table for input to R on a time-window from the time series of activations in selected labels
====================================================
The label is not subject-specific but defined from fsaverage brain

"""
# Author: Alexandre Gramfort <gramfort@nmr.mgh.harvard.edu>
#         modified by Ellen Lau
# License: BSD (3-clause)

# run source_roiWin2R_Baleen.py ya.n22.meeg 300 500 spm

print __doc__

import mne
import numpy as np
import scipy
import argparse
import readInput
import writeOutput


###################################
########SETUP######################
###################################


##Get input arguments
parser = argparse.ArgumentParser(description='Get input')
parser.add_argument('prefix',type=str)
parser.add_argument('t1',type=float)
parser.add_argument('t2',type=float)
parser.add_argument('model',type=str)

args=parser.parse_args()


##Set data path
data_path = '/cluster/kuperberg/SemPrMM/MEG/results/source_space/ga_stc'

##Set the factors to examine
protocolList = ['BaleenLP_All', 'BaleenLP_All', 'BaleenHP_All', 'BaleenHP_All']
condList = ['1', '2', '1', '2']
hemList = ['lh','rh']
labelList = ['G_front_inf-Opercular', 'G_front_inf-Triangul','G_front_inf-Orbital', 'Pole_temporal', 'G_temp_ant-sup-Lateral','G_temp_post-sup-Lateral','S_temporal_ant-sup','S_temporal_post-sup','G_temporal_ant-middle','G_temporal_post-middle','G_temporal_inf','S_temporal_inf','G_pariet_inf-Angular','G_temp_sup-Plan_polar','aparc2009-aMTGSTS','aparc2009-pMTGSTS','aparc2009-IFG']

##Convert input times from ms to samples
baseline=100 #ms
sample1 = int( round( (args.t1+baseline)/1.6667 ) )
sample2 = int( round( (args.t2+baseline)/1.6667 ) )

###Get subject list
subjFile = '/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/' + args.prefix + '.txt'
subjects = readInput.readList(subjFile)
print subjects



###################################
########MAKE DATA TABLE############
###################################


dataTable = []

for x in range(4):
	print protocolList[x]
	
	for label in labelList:
		for hem in hemList:
		
			stcs_fname = ['/cluster/kuperberg/SemPrMM/MEG/data/ya%s/ave_projon/stc/%s/ya%s_%s_c%sM-%s-%s.stc' % (s, protocolList[x], s, protocolList[x],condList[x],args.model,hem) for s in subjects]
			
			label_fname = data_path + '/label/%s-%s.label' % (label, hem)
			
	
			valuesAll = []
			for stc_fname in stcs_fname:
				values, times, vertices = mne.label_time_courses(label_fname, stc_fname)
				values = np.mean(values,0)
				values = values[sample1:sample2]
				values = np.mean(values,0)
				valuesAll.append(values)
				
			##Update output table	
			count = 0
			for s in subjects:
				data = valuesAll[count]
				row = [s, protocolList[x]+condList[x], label, hem, data]
				dataTable.append(row)
				count = count + 1
		
fileName = '/cluster/kuperberg/SemPrMM/MEG/results/source_space/R/'+args.prefix+'.BaleenAll.2x2.'+args.model+'.'+str(int(args.t1))+'-'+str(int(args.t2))+'.txt'

writeOutput.writeTable(fileName, dataTable)

