import readInput
import writeOutput
import sys
import os
from mne import fiff


##THIS SCRIPT BASED OFF OF FIXTRIGGERS, WILL BE RUN AFTER PREPROC_AVG AND EQUALIZE EXACTLY # OF TRIGGERS


def equalizeTriggers(subjID):    

    os.chdir("/cluster/kuperberg/SemPrMM/MEG/data/"+subjID)
    
    #expList = ['ATLLoc','MaskedMM','BaleenLP','BaleenHP','AXCPT']
    expList = ['AXCPT']
    runDict = { 'ATLLoc':[''],'MaskedMM':['Run1','Run2'],'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4'],'AXCPT':['Run1','Run2']}

    codeGroupDict = { 'AXCPT':['AXCPT_prime','AXCPT_target']}

    codeDict = { 'AXCPT_prime':['5','6'],'AXCPT_target':['1','2','3']}
    minDict = {}
    
    if subjID == 'ya3':
        runDict['AXCPT']=['Run1']
    if (subjID == 'ya1' or subjID == 'ya2' or subjID == 'ya4' or subjID == 'ya7' or subjID == 'ya8' or subjID == 'ya16'):
        runDict['AXCPT']=''
                
        
    #########################
    ##EQUALIZE TRIGGER COUNTS###
    print '----equalize triggers'
    for exp in expList:
        for codeGroup in codeGroupDict[exp]:
            evMin = 9999
            for code in codeDict[codeGroup]:
                    print int(code)-1
                    aveName = '/cluster/kuperberg/SemPrMM/MEG/data/%s/ave_projon/%s_%s_All-ave.fif' % (subjID, subjID, exp)
                    print aveName
                    evoked = fiff.Evoked(aveName,setno=int(code)-1) #needs revision
                    print evoked.nave
                    if int(evoked.nave) < evMin:
                        evMin = int(evoked.nave)
            minDict[codeGroup] = evMin
            print codeGroup, evMin, minDict[codeGroup]

            
        for run in runDict[exp]:
            inFile = 'eve/' + subjID + '_'+exp+run+'ModRej4projoff.eve'
            outFile = 'eve/' + subjID + '_' + exp + run + 'ModRej.eve' #when finalized, this should probably be ModRejEq.eve, and later scripts changed
            print inFile
            if os.path.exists(inFile):
                    data = readInput.readTable(inFile)
                    
                    firstRow = data[0]
                    firstSample = firstRow[0]
                    firstTime = firstRow[1]

                    flag = ''
                    
                    for row in data:
                        trigger = row[3]
                        time = row[1]


                    writeOutput.writeTable(outFile,data)
                                       

if __name__ == "__main__":
    subjID = sys.argv[1]
    equalizeTriggers(subjID)
