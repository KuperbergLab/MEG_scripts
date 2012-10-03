###SemPrMM
###Make .ave files
###usage: python <this script.py> subjectID projType
###ex: python makeAveFiles.py ya16 projoff

import sys
import condCodes as cc

def makeAveFiles(subjID,projType):
	
	filePrefix = '/cluster/kuperberg/SemPrMM/MEG/data/'+subjID
	
 	gradRej = "2000e-13"
 	magRej = "3000e-15"
 	eegRej = "100e-6"


	## SUBJECT-SPECIFIC REJECTION THRESHOLD MODIFICATIONS
 	if subjID == "ya31" or subjID == 'sc9':
 		magRej = "4000e-15"   ##note exception for ya31 and sc9, whose magnetometers were baseline noisy
 	
 	if subjID == "ya5" or subjID == "ya21" or subjID == "ya18" or subjID == "ya27" or subjID == "ya31":
 		eegRej = "150e-6"   ##because of alpha for ya21
 	
 	if subjID == "ya23":
 		eegRej = "125e-6"
 
  	if subjID == "ya15":
		eegRej = "80e-6"
		
		
	if subjID == "ya26":
		eegRej = "90e-6"
	
##	expList = ['Blink', 'ATLLoc','MaskedMM','BaleenLP','BaleenHP','AXCPT']
        expList = ['BaleenHP'] ## changed on 9/7 for testing number of trials in each case(rej, PCA+rej, PCA+norej -CU)
	
	runDict = {'Blink':[''],'ATLLoc':[''],'MaskedMM':['Run1','Run2'],'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4'],'AXCPT':['Run1','Run2']}
	
	condDict = cc.condLabels
	epMaxDict = cc.epMax


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
                                if projType == 'projoff':
                                        myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_' +exp + run + 'ModRej4projoff.eve\n\n')
                                if projType == 'projon':
                                        myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_' +exp + run + 'ModRej.eve\n\n')
                                	myFile.write('\tgradReject\t'+gradRej + '\n\n')
                                	myFile.write('\tmagReject\t'+magRej + '\n\n')
                                	myFile.write('\teegReject\t'+eegRej + '\n\n')
                                
                                for item in condDict[exp]:
                                        myFile.write('\tcategory {\n')
                                        myFile.write('\t\tname\t\"'+item[1]+'\"\n')
                                        myFile.write('\t\tevent\t'+item[0]+'\n')
                                        myFile.write('\t\ttmin\t-0.1\n')
                                        if exp == 'ATLLoc' and (item[0] == '1' or item[0] == '2' or item[0] == '3'):
                                                myFile.write('\t\ttmax\t' + '3.6' + '\n\t}\n\n')
                                        else:
                                                myFile.write('\t\ttmax\t' + epMaxDict[exp] + '\n\t}\n\n')
                                if exp=='BaleenHP':
                                        myFile.write('\tcategory {\n')
                                        myFile.write('\t\tname\t\"'+'Related 120'+'\"\n')
                                        myFile.write('\t\tevent\t'+'6'+'\n')
                                        myFile.write('\t\tevent\t'+'8'+'\n')                                        
                                        myFile.write('\t\ttmin\t-0.1\n')
                                        myFile.write('\t\ttmax\t' + epMaxDict[exp] + '\n\t}\n\n')
                                        myFile.write('\tcategory {\n')
                                        myFile.write('\t\tname\t\"'+'Unrelated 120'+'\"\n')
                                        myFile.write('\t\tevent\t'+'7'+'\n')
                                        myFile.write('\t\tevent\t'+'9'+'\n')                                        
                                        myFile.write('\t\ttmin\t-0.1\n')
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
                                myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_' +exp + run + '.eve\n\n')           
                                
                                for item in condDict[exp]:
                                        myFile.write('\tcategory {\n')
                                        myFile.write('\t\tname\t\"'+item[1]+'\"\n')
                                        myFile.write('\t\tevent\t'+item[0]+'\n')
                                        myFile.write('\t\ttmin\t-0.1\n')
                                        myFile.write('\t\ttmax\t' + epMaxDict[exp] + '\n\t}\n\n')
                                
                                myFile.write('}\n')
                                
		
if __name__ == "__main__":
	makeAveFiles(sys.argv[1],sys.argv[2])
