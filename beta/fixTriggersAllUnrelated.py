import readInput
import writeOutput
import sys
import os

##This script creates a common code for unrelated targets, whether experimental items or fillers, in the Baleen scripts. In BaleenLP, the resulting code is 3, in BaleenHP, the resulting code is 8.

##Note that this script takes effect *after* artifact rejection

def fixTriggersAllUnrelated(subjID):    

    os.chdir("/cluster/kuperberg/SemPrMM/MEG/data/"+subjID)
    
    expList = ['BaleenLP','BaleenHP']
    
    runDict = {'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4']}
    
        
    ###############################################
    #BALEEN Change all codes to Unrelated 
    
    for exp in expList:
        for run in runDict[exp]:
			inFile = 'eve/'+subjID+'_'+exp+run+'ModRej.eve'
			outFile = 'eve/'+subjID+'_'+exp+run+'ModRejAllU.eve'
			if os.path.exists(inFile):
				data = readInput.readTable(inFile)
				
				rowCount = 0
				flag2 = 0
				for row in data:
					trigger = row[3]
					
					#BaleenLP
					if trigger == '2':
						row[3] = '4'
					
					#BaleenHP

					if trigger == '7':
						row[3] = '9'
						
					rowCount +=1
				
				writeOutput.writeTable(outFile, data)


if __name__ == "__main__":
    subjID = sys.argv[1]
    fixTriggersAllUnrelated(subjID)
