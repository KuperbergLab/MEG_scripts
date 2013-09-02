###SemPrMM
###Make ModRej4projoff.ave files from the Mod.eve files created using projon
###usage: python <this script.py> subjectID 
###ex: python projonrej2eve.py ac1

import readInput
import writeOutput
import sys
import os

def  rej_rej2eve_projon_ecgeog_norej(subjID):
	
	filePrefix = '/cluster/kuperberg/SemPrMM/MEG/data/'+subjID
	
	expList = ['BaleenLP','BaleenHP']
	###expList = ['ATLLoc','MaskedMM','BaleenLP','BaleenHP','AXCPT']
	runDict = {'ATLLoc':[''],'MaskedMM':['Run1','Run2'],'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4'], 'AXCPT':['Run1','Run2']}
	

	for exp in expList:
                print exp
                for run in runDict[exp]:
                        inFile1 = filePrefix + '/ave_projon/logs/ssp_avelogs/' + subjID + '_' + exp + run + '_ecgeog_norej-ave.log'
                        inFile2 = filePrefix + '/eve/' + subjID + '_' + exp + run + 'Mod.eve'
                        outFile = filePrefix + '/eve/' + subjID + '_' + exp + run + 'Mod4projoff.eve'
##                        print inFile1
##                        print inFile2
##                        print('Step1 done')
                        if os.path.exists(outFile):
                                os.remove(outFile)
                        
                        if os.path.exists(inFile1) and os.path.exists(inFile2):
                                data1 = readInput.readTable(inFile1)
                                rowsin1 = len(data1)
                                data2 = readInput.readTable(inFile2)
                                rowsin2 = len(data2)
                                firstLine = data2[0]
                                firstTimept = int((firstLine[0]))
                ##                        print(firstTimept)
                                timept1=timept2=[]
                                for i in range (0, len(data1)):
                                        lineTemp1 = data1[i]
                                        if len(lineTemp1) > 10:
                                                timept1.append((lineTemp1[0]))
                                print(timept1)

                                for i in range (0, len(data2)):
                                        lineTemp2 = data2[i]
                                        timeN = int(lineTemp2[0])
                                        timept2= str(timeN - firstTimept)
                                        if str(timept2) in timept1:
                                                lineTemp2[3] = 4000 + int(lineTemp2[3])

                                writeOutput.writeTable(outFile,data2)
#                                 g = os.path.getsize(outFile)    
#                                 print g               


                
                    
if __name__ == "__main__":
 rej_rej2eve_projon_ecgeog_norej(sys.argv[1])                    
                    
                    
                    
