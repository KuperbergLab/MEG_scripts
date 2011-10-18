###SemPrMM
###Make .ave files
###usage: python <this script.py> subjectID 
###ex: python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py ya16 

import sys

def makeAveFilesAllUnrelated(subjID):
	
	filePrefix = '/cluster/kuperberg/SemPrMM/MEG/data/'+subjID
	
	epMaxBaleen = ".7"
# 	gradRej = "2500e-13"
# 	eegRej = "100e-6"
	
	expList = ['BaleenLP','BaleenHP']
	
	runDict = {'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4']}
	
	condDict = {'BaleenLP':[['4','Unrelated Filler']],'BaleenHP': [['9','Unrelated']]}
	
	epMaxDict = {'BaleenLP':epMaxBaleen,'BaleenHP':epMaxBaleen}

	
	for exp in expList:
		for run in runDict[exp]:
	
			filename = filePrefix + '/ave/'+subjID + '_' + exp + run + 'AllUnrelated.ave'
			print filename
							
			myFile = open(filename, "w")
			myFile.close()	
				
			myFile = open(filename, "a")
			myFile.write('average {\n\n')
			myFile.write('\tname\t\"'+ exp + ' averages\"\n\n')
			myFile.write('\toutfile\t\t'+subjID+ '_' + exp + run + '-ave.fif\n')
			myFile.write('\tlogfile\t\t./logs/'+subjID + '_' + exp + run + 'AllUnrelated-ave.log\n')
			myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_' +exp + run + 'ModRejAllU.eve\n\n')
#			myFile.write('\tgradReject\t'+gradRej + '\n\n')
#			myFile.write('\teegReject\t'+eegRej + '\n\n')
			
			for item in condDict[exp]:
				myFile.write('\tcategory {\n')
				myFile.write('\t\tname\t\"'+item[1]+'\"\n')
				myFile.write('\t\tevent\t'+item[0]+'\n')
				myFile.write('\t\ttmin\t-0.1\n')
				if exp == 'ATLLoc' and (item[0] == '1' or item[0] == '2' or item[0] == '3'):
					myFile.write('\t\ttmax\t' + '3.6' + '\n\t}\n\n')
				else:
					myFile.write('\t\ttmax\t' + epMaxDict[exp] + '\n\t}\n\n')
			
			myFile.write('}\n')
	

		
if __name__ == "__main__":
	makeAveFilesAllUnrelated(sys.argv[1])
