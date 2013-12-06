import readInput
import writeOutput
import sys
import os
import mne
from mne import fiff
from mne import Epochs
from mne.epochs import equalize_epoch_counts


##THIS SCRIPT BASED OFF OF FIXTRIGGERS, WILL BE RUN AFTER PREPROC_AVG AND EQUALIZE EXACTLY # OF TRIGGERS


def equalizeTriggers(subjID):    

    os.chdir("/cluster/kuperberg/SemPrMM/MEG/data/"+subjID)
    
    expList = ['ATLLoc','MaskedMM','BaleenLP','BaleenHP','AXCPT']
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
            inFile = 'eve/' + subjID + '_'+exp+run+'Mod.eve'
            outFile = 'eve/' + subjID + '_' + exp + run + 'Mod-testeq.eve' #when finalized, this should probably be ModRejEq.eve, and later scripts changed
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

def equalize_AXCPT(subjID): 

   print "Jane here!"
   event_id = {'A_prime':5, 'B_prime':6}
   rawfname = '/cluster/kuperberg/SemPrMM/MEG/data/' +subjID + '/' +subjID + '_AXCPTRun1_raw.fif'
   raw = fiff.Raw(rawfname)
 #  eventsfname =  '/cluster/kuperberg/SemPrMM/MEG/data/%s/eve/%s_AXCPTRun1.eve' % (subjID, subjID)
   eventsfname =  '/cluster/kuperberg/SemPrMM/MEG/data/%s/%s_AXCPTRun1_raw-eve.fif' % (subjID, subjID)
   events = mne.read_events(eventsfname)
   APrime_event_id = 5
   BPrime_event_id = 6
##   AX_event_id = 4
##   AY_event_id = 1
##   BX_event_id = 2
##   BY_event_id = 3
   tmin = -0.1
   tmax = 0.7
   APrimeEpochs = mne.Epochs(raw, events, APrime_event_id, tmin, tmax)
   BPrimeEpochs = mne.Epochs(raw, events, BPrime_event_id, tmin, tmax)
##   AXEpochs = mne.Epochs(raw, events, AX_event_id, tmin, tmax)
##   AYEpochs = mne.Epochs(raw, events, AY_event_id, tmin, tmax)
##   BXEpochs = mne.Epochs(raw, events, BX_event_id, tmin, tmax)
##   BYEpochs = mne.Epochs(raw, events, BY_event_id, tmin, tmax)
   print "A Prime before"
   print APrimeEpochs
   print "B Prime before"
   print BPrimeEpochs   
   mne.epochs.equalize_epoch_counts([APrimeEpochs, BPrimeEpochs]) ## tried mintime and truncate, default is fine
   print "A Prime After"
   print APrimeEpochs
   print "B Prime After"
   print BPrimeEpochs 
                                       

if __name__ == "__main__":
    subjID = sys.argv[1]
  #  equalizeTriggers(subjID)
    equalize_AXCPT(subjID)
