###SemPrMM
###Make .ave files
###usage: python <this script.py> subjectID preBlinkTime postBlinkTime
###ex: python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py ya16 -0.1 0.4

import sys

subjID = sys.argv[1]
preBlinkTime = sys.argv[2]
postBlinkTime = sys.argv[3]
print("preBlinkTime:{0}\tpostBlinkTime:{1}".format(preBlinkTime,postBlinkTime))

filePrefix = '/cluster/kuperberg/SemPrMM/MEG/data/'+subjID

epMaxATL = ".5"   ## time in seconds for the end of the epoch (e.g. 900 ms post-stim onset)
epMaxMasked = ".5"
epMaxBaleen = ".7"

###############
##Blink .ave###

#SB 20110119 Not exactly sure what to do with Blinks yet, need to hook into ica stream

filename = filePrefix + '/ave/'+subjID + '_Blink.ave'
print filename

gradRej = "2500e-13"


myFile = open(filename, "w")
myFile.close()	
	
myFile = open(filename, "a")
myFile.write('average {\n\n')
myFile.write('\tname\t\"Blink average\"\n\n')
myFile.write('\toutfile\t\t'+subjID+ '_Blink' + '-ave.fif\n')
myFile.write('\tlogfile\t\t./logs/'+subjID + '_Blink' + '-ave.log\n')
myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_Blink' + '.eve\n\n')
myFile.write('\tgradReject\t'+gradRej + '\n\n')

myFile.write('\tcategory {\n')
myFile.write('\t\tname\t\"Blink\"\n')
myFile.write('\t\tevent\t1\n')
myFile.write('\t\ttmin\t-0.1\n')
myFile.write('\t\ttmax\t' + '900' + '\n\t}\n\n')

myFile.write('}\n')

###############
##ATLLoc .ave###

filename = filePrefix + '/ave/'+subjID + '_ATLLoc.ave'
print filename

myFile = open(filename, "w")
myFile.close()	
	
myFile = open(filename, "a")
myFile.write('average {\n\n')
myFile.write('\tname\t\"ATLLoc averages\"\n\n')
myFile.write('\toutfile\t\t'+subjID+ '_ATLLoc' + '-ave.fif\n')
myFile.write('\tlogfile\t\t./logs/'+subjID + '_ATLLoc' + '-ave.log\n')
#myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_ATLLocMod.eve\n\n')
myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_ATLLocModblink.eve\n\n')
myFile.write('\tgradReject\t'+gradRej + '\n\n')

myFile.write('\tcategory {\n')
myFile.write('\t\tname\t\"Sentences\"\n')
myFile.write('\t\tevent\t41\n')
myFile.write('\t\ttmin\t-0.1\n')
myFile.write('\t\ttmax\t'+epMaxATL+'\n\t}\n\n')

myFile.write('\tcategory {\n')
myFile.write('\t\tname\t\"Word Lists\"\n')
myFile.write('\t\tevent\t42\n')
myFile.write('\t\ttmin\t-0.1\n')
myFile.write('\t\ttmax\t'+epMaxATL+'\n\t}\n\n')

myFile.write('\tcategory {\n')
myFile.write('\t\tname\t\"Consonant Strings\"\n')
myFile.write('\t\tevent\t43\n')
myFile.write('\t\ttmin\t-0.1\n')
myFile.write('\t\ttmax\t'+epMaxATL+'\n\t}\n\n')

myFile.write('\tcategory {\n')
myFile.write('\t\tname\t\"Sentence First Word\"\n')
myFile.write('\t\tevent\t1\n')
myFile.write('\t\ttmin\t-0.1\n')
myFile.write('\t\ttmax\t3.6\n\t}\n\n')

myFile.write('\tcategory {\n')
myFile.write('\t\tname\t\"Word List First Word\"\n')
myFile.write('\t\tevent\t2\n')
myFile.write('\t\ttmin\t-0.1\n')
myFile.write('\t\ttmax\t3.6\n\t}\n\n')

myFile.write('\tcategory {\n')
myFile.write('\t\tname\t\"Consonant String First Word\"\n')
myFile.write('\t\tevent\t3\n')
myFile.write('\t\ttmin\t-0.1\n')
myFile.write('\t\ttmax\t3.6\n\t}\n\n')


myFile.write('}\n')
myFile.close()	



###################
##MaskedMM .ave###

runLP = ['1', '2']

for runNum in runLP:
	filename = filePrefix + '/ave/'+subjID + '_MaskedMMRun' + runNum + '.ave'
	print filename
	
	myFile = open(filename, "w")
	myFile.close()	
		
	myFile = open(filename, "a")
	myFile.write('average {\n\n')
	myFile.write('\tname\t\"MaskedMM averages\"\n\n')
	myFile.write('\toutfile\t\t'+subjID+ '_MaskedMMRun' + runNum + '-ave.fif\n')
	myFile.write('\tlogfile\t\t./logs/'+subjID + '_MaskedMMRun' + runNum +  '-ave.log\n')
	#myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_MaskedMMRun' + runNum + '.eve\n\n')
	myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_MaskedMMRun' + runNum + 'Modblink.eve\n\n')
	myFile.write('\tgradReject\t'+gradRej + '\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"Direct\"\n')
	myFile.write('\t\tevent\t1\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxMasked+'\n\t}\n\n')

	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"Indirect\"\n')
	myFile.write('\t\tevent\t2\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxMasked+'\n\t}\n\n')

	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"Unrelated\"\n')
	myFile.write('\t\tevent\t3\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxMasked+'\n\t}\n\n')

	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"ProbeTarget\"\n')
	myFile.write('\t\tevent\t4\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxMasked+'\n\t}\n\n')


	myFile.write('}\n')
	myFile.close()	

	
###################
##BaleenLP .ave###

runLP = ['1', '2', '3', '4']

for runNum in runLP:
	filename = filePrefix + '/ave/'+subjID + '_BaleenRun' + runNum + '.ave'
	print filename
	
	myFile = open(filename, "w")
	myFile.close()	
		
	myFile = open(filename, "a")
	myFile.write('average {\n\n')
	myFile.write('\tname\t\"BaleenLP averages\"\n\n')
	myFile.write('\toutfile\t\t'+subjID+ '_BaleenRun' + runNum + '-ave.fif\n')
	myFile.write('\tlogfile\t\t./logs/'+subjID + '_BaleenRun' + runNum +  '-ave.log\n')
	#myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_BaleenRun' + runNum + 'Mod.eve\n\n')
	myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_BaleenRun' + runNum + 'Modblink.eve\n\n')
	myFile.write('\tgradReject\t'+gradRej + '\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"RelLP\"\n')
	myFile.write('\t\tevent\t1\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxBaleen+'\n\t}\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"UnrelLP\"\n')
	myFile.write('\t\tevent\t2\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxBaleen+'\n\t}\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"UnrelFillerLP\"\n')
	myFile.write('\t\tevent\t4\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxBaleen+'\n\t}\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"ProbeTarLP\"\n')
	myFile.write('\t\tevent\t5\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxBaleen+'\n\t}\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"ProbePrimeLP\"\n')
	myFile.write('\t\tevent\t11\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxBaleen+'\n\t}\n\n')

	
	myFile.write('}\n')
	
	myFile.close()	


###################
##BaleenHP .ave###

runHP = ['5', '6', '7', '8']

for runNum in runHP:
	filename = filePrefix + '/ave/'+subjID + '_BaleenRun' + runNum + '.ave'
	print filename
	
	myFile = open(filename, "w")
	myFile.close()	
		
	myFile = open(filename, "a")
	myFile.write('average {\n\n')
	myFile.write('\tname\t\"BaleenHP averages\"\n\n')
	myFile.write('\toutfile\t\t'+subjID+ '_BaleenRun' + runNum + '-ave.fif\n')
	myFile.write('\tlogfile\t\t./logs/'+subjID + '_BaleenRun' + runNum +  '-ave.log\n')
	#myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_BaleenRun' + runNum + '.eve\n\n')
	myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_BaleenRun' + runNum + 'Modblink.eve\n\n')
	myFile.write('\tgradReject\t'+gradRej + '\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"RelHP\"\n')
	myFile.write('\t\tevent\t6\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxBaleen+'\n\t}\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"UnrelHP\"\n')
	myFile.write('\t\tevent\t7\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxBaleen+'\n\t}\n\n')

	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"RelFillerHP\"\n')
	myFile.write('\t\tevent\t8\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxBaleen+'\n\t}\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"UnrelFillerHP\"\n')
	myFile.write('\t\tevent\t9\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxBaleen+'\n\t}\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"ProbeTarHP\"\n')
	myFile.write('\t\tevent\t10\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxBaleen+'\n\t}\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"ProbePrimeHP\"\n')
	myFile.write('\t\tevent\t12\n')
	myFile.write('\t\ttmin\t-0.1\n')
	myFile.write('\t\ttmax\t'+epMaxBaleen+'\n\t}\n\n')


	myFile.close()	
