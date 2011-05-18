###SemPrMM
###Make .ave files
###usage: python <this script.py> subjectID preBlinkTime postBlinkTime
###ex: python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py ya16 -0.1 0.4

import sys

def makeAveFiles(subjID,preBlinkTime,postBlinkTime):
	print("preBlinkTime:{0}\tpostBlinkTime:{1}".format(preBlinkTime,postBlinkTime))
	
	filePrefix = '/cluster/kuperberg/SemPrMM/MEG/data/'+'test'##+subjID
	
	epMaxATL = ".5"   ## time in seconds for the end of the epoch (e.g. 900 ms post-stim onset)
	epMaxMasked = ".5"
	epMaxBaleen = ".7"
	epMaxAXCPT = ".7"
	
	expList = ['Blink', 'ATLLoc','MaskedMM','BaleenLP','BaleenHP','AXCPT']
	
	runDict = {'Blink':[''],'ATLLoc':[''],'MaskedMM':['Run1','Run2'],'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4'],'AXCPT':['Run1','Run2']}
	
	condDict = {'Blink':[['1','Blink']],'ATLLoc':[['41','Sentences'],['42','Word Lists'],['43','Consonant Strings'],['1','Sentence First Word'],['2','Word List First Word'],['3','Consonant String First Word']],'MaskedMM': [['1','Direct'],['2','Indirect'],['3','Unrelated'],['4','Probe Target']],'BaleenLP':[['1','Related'],['2','Unrelated'],['4','Unrelated Filler'],['5','Probe Target']],'BaleenHP': [['6','Related'],['7','Unrelated'],['8','Related Filler'],['9','Unrelated Filler'],['10','Probe Target']],'AXCPT':[['1','AY'],['2','BX'],['3','BY'],['4','AX'],['5','A'],['6','B']]}
	
	
	epMaxDict = {'Blink':'.9','ATLLoc':'.5','MaskedMM':'.5','BaleenLP':'.7','BaleenHP':'.7','AXCPT':'.7'}
	

	#SB 20110119 Not exactly sure what to do with Blinks yet, need to hook into ica stream
	
	
	for exp in expList:
		for run in runDict[exp]:
	
			filename = filePrefix + '/ave/'+subjID + '_' + exp + run + '.ave'
			print filename
			
			gradRej = "2500e-13"
				
			myFile = open(filename, "w")
			myFile.close()	
				
			myFile = open(filename, "a")
			myFile.write('average {\n\n')
			myFile.write('\tname\t\"'+ exp + ' averages\"\n\n')
			myFile.write('\toutfile\t\t'+subjID+ '_' + exp + run + '-ave.fif\n')
			myFile.write('\tlogfile\t\t./logs/'+subjID + '_' + exp + run + '-ave.log\n')
			myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_' +exp + run + 'ModBlink.eve\n\n')
			myFile.write('\tgradReject\t'+gradRej + '\n\n')
			
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
	subjID = sys.argv[1]
	preBlinkTime = sys.argv[2]
	postBlinkTime = sys.argv[3]
	makeAveFiles(subjID,preBlinkTime,postBlinkTime)