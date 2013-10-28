###SemPrMM
###Make .cov files

import sys

def makeCovFiles(subjID):
	
	tMin = '-0.1'  ##Time in seconds (from trigger) for the beginning of epoch used to estimate covariance
	filePrefix = '/cluster/kuperberg/SemPrMM/MEG/data/'+subjID
	gradRej = "2000e-13"
	magRej = "3000e-15"
	eegRej = "100e-6"
        magFlat = "1e-14"
	gradFlat = "1000e-15"
	
 	if subjID == "ya31" or subjID == 'sc9':
 		magRej = "4000e-15"   ##note exception for ya31, whose magnetometers were baseline noisy
 		
  	if subjID == "ya21" or subjID == "ya18" or subjID == "ya27" or subjID == "ya31":
 		eegRej = "150e-6"   ##because of alpha for ya21
 	
 	if subjID == "ya23":
 		eegRej = "125e-6"
 
  	if subjID == "ya15":
		eegRej = "80e-6"
		
	if subjID == "ya26":
		eegRej = "90e-6"

	if subjID == "ac2" or subjID == "ac7" or subjID == "sc19" or subjID == "sc6": 
		eegRej = "1"
		
	if subjID == "sc17":
	      eegRej = "250e-6"
	      
	if subjID == "sc20":
		eegRej = "1"


		
	
	expList = ['MaskedMM','BaleenLP','BaleenHP','AXCPT']
	
	runDict = {'MaskedMM':['Run1','Run2'],'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4'],'AXCPT':['Run1','Run2']}
	
	condDict = {'MaskedMM':[['14','Prime']], 'BaleenLP':[['14','Prime'],['11','Prime Probe']],'BaleenHP':[['14','Prime'],['12','Prime Probe']],'AXCPT':[['1','AY target'],['2','BX target'],['3','BY target'],['4','AX target'],['5','A prime'],['6','B prime']]}

        if subjID == "sc3":
                
              condDict = {'MaskedMM': [['6', 'Prime']],'BaleenLP':[['14','Prime'],['11','Prime Probe']],'BaleenHP':[['14','Prime'],['12','Prime Probe']],'AXCPT':[['1','AY target'],['2','BX target'],['3','BY target'],['4','AX target'],['5','A prime'],['6','B prime']]}

	for exp in expList:
		for run in runDict[exp]:
	
			filename = filePrefix + '/cov/'+subjID + '_' + exp + run + '.cov'
			print filename
							
			myFile = open(filename, "w")
			myFile.close()	

			myFile = open(filename, "a")
			myFile.write('cov {\n\n')
			myFile.write('\tname\t\"' + exp + '\"\n\n')
			myFile.write('\toutfile\t\t'+subjID+ '_' + exp + run +'-cov.fif\n')
			myFile.write('\tlogfile\t\t./logs/'+subjID + '_' + exp + run +  '-cov.log\n')
			myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_' +exp + run + 'Mod.eve\n\n')
			myFile.write('\tgradReject\t'+gradRej + '\n\n')
			myFile.write('\tmagReject\t'+magRej + '\n\n')
					
			for item in condDict[exp]:
				myFile.write('\tdef {\n')
				myFile.write('\t\tname\t\"'+item[1]+'\"\n')
				myFile.write('\t\tevent\t'+item[0]+'\n')
				myFile.write('\t\tignore\t0\n')
				myFile.write('\t\ttmin\t'+tMin+'\n')
				myFile.write('\t\ttmax\t-0.01\n')
				myFile.write('\t\tbmin\t'+tMin+'\n')
				myFile.write('\t\tbmax\t-0.01\n\t}\n\n')
			
			myFile.write('}\n')
		

	###################

	
if __name__ == "__main__":
	makeCovFiles(sys.argv[1])
