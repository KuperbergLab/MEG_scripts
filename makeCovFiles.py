###SemPrMM
###Make .cov files

import sys

def makeCovFiles(subjID):
	
	tMin = '-0.2'  ##Time in seconds (from trigger) for the beginning of epoch used to estimate covariance
	filePrefix = '/cluster/kuperberg/SemPrMM/MEG/data/'+subjID
	gradRej = "2500e-13"
	
	expList = ['MaskedMM','BaleenLP','BaleenHP','AXCPT']
	
	runDict = {'MaskedMM':['Run1','Run2'],'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4'],'AXCPT':['Run1','Run2']}
	
	condDict = {'MaskedMM':[['14','Prime']], 'BaleenLP':[['14','Prime'],['11','Prime Probe']],'BaleenHP':[['14','Prime'],['12','Prime Probe']],'AXCPT':[['1','AY target'],['2','BX target'],['3','BY target'],['4','AX target'],['5','A prime'],['6','B prime']]}

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
			myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_' + exp + run + 'ModRej.eve\n\n')
#			myFile.write('\tgradReject\t'+gradRej + '\n\n')
					
			for item in condDict[exp]:
				myFile.write('\tdef {\n')
				myFile.write('\t\tname\t\"'+item[1]+'\"\n')
				myFile.write('\t\tevent\t'+item[0]+'\n')
				myFile.write('\t\tignore\t0\n')
				myFile.write('\t\ttmin\t'+tMin+'\n')
				myFile.write('\t\ttmax\t-0.01\n')
				myFile.write('\t\tbmin\t'+tMin+'\n')
				myFile.write('\t\tbmax\t-.01\n\t}\n\n')
			
			myFile.write('}\n')
		

	###################

	
if __name__ == "__main__":
	makeCovFiles(sys.argv[1])