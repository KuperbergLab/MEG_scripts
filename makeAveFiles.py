###SemPrMM
###Make .ave files
###usage: python <this script.py> subjectID projType
###ex: python makeAveFiles.py ya16 projoff

import sys

def makeAveFiles(subjID,projType):
	
	filePrefix = '/cluster/kuperberg/SemPrMM/MEG/data/'+subjID
	
	epMaxATL = ".5"   ## time in seconds for the end of the epoch (e.g. 900 ms post-stim onset)
	epMaxMasked = ".7"
	epMaxBaleen = ".7"
	epMaxAXCPT = ".7"
 	gradRej = "2000e-13"
 	magRej = "3000e-15"

 	if subjID == "ya31":
 		magRej = "4000e-15"   ##note exception for ya31, whose magnetometers were baseline noisy
	
	expList = ['Blink', 'ATLLoc','MaskedMM','BaleenLP','BaleenHP','AXCPT']
	
	runDict = {'Blink':[''],'ATLLoc':[''],'MaskedMM':['Run1','Run2'],'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4'],'AXCPT':['Run1','Run2']}
	
	condDict = {'Blink':[['1','Blink']],'ATLLoc':[['41','Sentences'],['42','Word Lists'],['43','Consonant Strings'],['1','Sentence First Word'],['2','Word List First Word'],['3','Consonant String First Word']],'MaskedMM': [['1','Direct'],['2','Indirect'],['3','Unrelated'],['4','Probe Target']],'BaleenLP':[['1','Related'],['2','Unrelated'],['4','Unrelated Filler'],['5','Probe Target']],'BaleenHP': [['6','Related'],['7','Unrelated'],['8','Related Filler'],['9','Unrelated Filler'],['10','Probe Target'],['18','Related Filler Extra']],'AXCPT':[['1','AY target'],['2','BX target'],['3','BY target'],['4','AX target'],['5','A prime'],['6','B prime']]}
	
	epMaxDict = {'Blink':'.9','ATLLoc':epMaxATL,'MaskedMM':epMaxMasked,'BaleenLP':epMaxBaleen,'BaleenHP':epMaxBaleen,'AXCPT':epMaxAXCPT}
	


	for exp in expList:
                 if exp == 'ATLLoc'or exp =='MaskedMM'or exp=='BaleenLP'or exp=='BaleenHP'or exp=='AXCPT':
                        for run in runDict[exp]:
                                filename = filePrefix + '/ave/'+subjID + '_' + exp + run + '.ave'
                                print filename
                                                                
                                myFile = open(filename, "w")
                                myFile.close()	
                                        
                                myFile = open(filename, "a")
                                myFile.write('average {\n\n')
                                myFile.write('\tname\t\"'+ exp + ' averages\"\n\n')
                                myFile.write('\toutfile\t\t'+subjID+ '_' + exp + run + '-ave.fif\n')
                                myFile.write('\tlogfile\t\t./logs/'+subjID + '_' + exp + run + '-ave.log\n')
                                myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_' +exp + run + 'ModRej.eve\n\n')
                                if projType == 'projon':
                                	myFile.write('\tgradReject\t'+gradRej + '\n\n')
                                	myFile.write('\tmagReject\t'+magRej + '\n\n')
                                
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
                 elif exp == 'Blink':
                        for run in runDict[exp]:
                                filename = filePrefix + '/ave/'+subjID + '_' + exp + run + '.ave'
                                print filename
                                                                
                                myFile = open(filename, "w")
                                myFile.close()	
                                        
                                myFile = open(filename, "a")
                                myFile.write('average {\n\n')
                                myFile.write('\tname\t\"'+ exp + ' averages\"\n\n')
                                myFile.write('\toutfile\t\t'+subjID+ '_' + exp + run + '-ave.fif\n')
                                myFile.write('\tlogfile\t\t./logs/'+subjID + '_' + exp + run + '-ave.log\n')
                                myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_' +exp + run + 'Mod.eve\n\n')           
                                
                                for item in condDict[exp]:
                                        myFile.write('\tcategory {\n')
                                        myFile.write('\t\tname\t\"'+item[1]+'\"\n')
                                        myFile.write('\t\tevent\t'+item[0]+'\n')
                                        myFile.write('\t\ttmin\t-0.1\n')
                                        myFile.write('\t\ttmax\t' + epMaxDict[exp] + '\n\t}\n\n')
                                
                                myFile.write('}\n')
                                
		
if __name__ == "__main__":
	makeAveFiles(sys.argv[1],sys.argv[2])
