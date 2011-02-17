###SemPrMM
###Make .ave files

import sys

subjID = sys.argv[1]
preBlinkTime = sys.argv[2]
postBlinkTime = sys.argv[3]
print("preBlinkTime:{0}\tpostBlinkTime:{1}".format(preBlinkTime,postBlinkTime))

tMin = '-0.2'  ##Time in seconds (from trigger) for the beginning of epoch used to estimate covariance
filePrefix = '/cluster/kuperberg/SemPrMM/MEG/data/'+subjID
gradRej = "2500e-13"


################
##ATLLoc .cov###

filename = filePrefix + '/cov/'+subjID + '_ATLLoc.cov'
print filename

myFile = open(filename, "w")
myFile.close()	

myFile = open(filename, "a")
myFile.write('cov {\n\n')
myFile.write('\tname\t\"ATLLoc\"\n\n')
myFile.write('\toutfile\t\t'+subjID+ '_ATLLoc' + '-cov.fif\n')
myFile.write('\tlogfile\t\t./logs/'+subjID + '_ATLLoc' + '-cov.log\n')
#myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_ATLLocMod.eve\n\n')
myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_ATLLocModblink.eve\n\n')
myFile.write('\tgradReject\t'+gradRej + '\n\n')

myFile.write('\tdef {\n')
myFile.write('\t\tname\t\"Sentences\"\n')
myFile.write('\t\tevent\t1\n')
myFile.write('\t\tignore\t0\n')
myFile.write('\t\ttmin\t'+tMin+'\n')
myFile.write('\t\ttmax\t-0.01\n')
myFile.write('\t\tbmin\t'+tMin+'\n')
myFile.write('\t\tbmax\t-.01\n\t}\n\n')

myFile.write('\tdef {\n')
myFile.write('\t\tname\t\"Noun Lists\"\n')
myFile.write('\t\tevent\t2\n')
myFile.write('\t\tignore\t0\n')
myFile.write('\t\ttmin\t'+tMin+'\n')
myFile.write('\t\ttmax\t-0.01\n')
myFile.write('\t\tbmin\t'+tMin+'\n')
myFile.write('\t\tbmax\t-.01\n\t}\n\n')

myFile.write('\tdef {\n')
myFile.write('\t\tname\t\"Consonant Strings\"\n')
myFile.write('\t\tevent\t3\n')
myFile.write('\t\tignore\t0\n')
myFile.write('\t\ttmin\t'+tMin+'\n')
myFile.write('\t\ttmax\t-0.01\n')
myFile.write('\t\tbmin\t'+tMin+'\n')
myFile.write('\t\tbmax\t-.01\n\t}\n\n')

myFile.write('}\n')

myFile.close()


###################
##MaskedMM .cov###

runLP = ['1', '2']

for runNum in runLP:
	filename = filePrefix + '/cov/'+subjID + '_MaskedMMRun' + runNum + '.cov'
	print filename
	
	myFile = open(filename, "w")
	myFile.close()	
		
	myFile = open(filename, "a")
	myFile.write('cov {\n\n')
	myFile.write('\tname\t\"MaskedMM\"\n\n')
	myFile.write('\toutfile\t\t'+subjID+ '_MaskedMMRun' + runNum + '-cov.fif\n')
	myFile.write('\tlogfile\t\t./logs/'+subjID + '_MaskedMMRun' + runNum +  '-cov.log\n')
	#myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_MaskedMMRun' + runNum + '.eve\n\n')
	myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_MaskedMMRun' + runNum + 'Modblink.eve\n\n')
	myFile.write('\tgradReject\t'+gradRej + '\n\n')


	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"Direct\"\n')
	myFile.write('\t\tevent\t1\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"Indirect\"\n')
	myFile.write('\t\tevent\t2\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"Unrelated\"\n')
	myFile.write('\t\tevent\t3\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"ProbeTarget\"\n')
	myFile.write('\t\tevent\t4\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')

	myFile.write('}\n')
	myFile.close()	
	
	
##BaleenLP .cov###

runLP = ['1', '2', '3', '4']

for runNum in runLP:
	filename = filePrefix + '/cov/'+subjID + '_BaleenRun' + runNum + '.cov'
	print filename
	
	myFile = open(filename, "w")
	myFile.close()	
		
	myFile = open(filename, "a")
	myFile.write('cov {\n\n')
	myFile.write('\tname\t\"BaleenLP\"\n\n')
	myFile.write('\toutfile\t\t'+subjID+ '_BaleenRun' + runNum + '-cov.fif\n')
	myFile.write('\tlogfile\t\t./logs/'+subjID + '_BaleenRun' + runNum +  '-cov.log\n')
	#myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_BaleenRun' + runNum + 'Mod.eve\n\n')
	myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_BaleenRun' + runNum + 'Modblink.eve\n\n')
	myFile.write('\tgradReject\t'+gradRej + '\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"RelLP\"\n')
	myFile.write('\t\tevent\t1\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')
	
	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"UnrelLP\"\n')
	myFile.write('\t\tevent\t2\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"UnrelFillerLP\"\n')
	myFile.write('\t\tevent\t4\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')
	
	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"ProbeTarLP\"\n')
	myFile.write('\t\tevent\t5\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"ProbePrimeLP\"\n')
	myFile.write('\t\tevent\t11\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')
	
	myFile.write('}\n')
	
	myFile.close()	
	
###################
##BaleenHP .cov###

runHP = ['5', '6', '7', '8']

for runNum in runHP:
	filename = filePrefix + '/cov/'+subjID + '_BaleenRun' + runNum + '.cov'
	print filename
	
	myFile = open(filename, "w")
	myFile.close()	
		
	myFile = open(filename, "a")
	myFile.write('cov {\n\n')
	myFile.write('\tname\t\"BaleenHP\"\n\n')
	myFile.write('\toutfile\t\t'+subjID+ '_BaleenRun' + runNum + '-cov.fif\n')
	myFile.write('\tlogfile\t\t./logs/'+subjID + '_BaleenRun' + runNum +  '-cov.log\n')
	#myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_BaleenRun' + runNum + '.eve\n\n')
	myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_BaleenRun' + runNum + 'Modblink.eve\n\n')
	myFile.write('\tgradReject\t'+gradRej + '\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"RelHP\"\n')
	myFile.write('\t\tevent\t6\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"UnrelHP\"\n')
	myFile.write('\t\tevent\t7\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"RelFillerHP\"\n')
	myFile.write('\t\tevent\t8\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"UnrelFillerHP\"\n')
	myFile.write('\t\tevent\t9\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"ProbeTarHP\"\n')
	myFile.write('\t\tevent\t10\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')

	myFile.write('\tdef {\n')
	myFile.write('\t\tname\t\"ProbePrimeHP\"\n')
	myFile.write('\t\tevent\t12\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')	

	myFile.write('}\n')
	myFile.close()	


###################
##AXCPT .ave###

runAX = ['1','2']
	

for runNum in runAX:
	filename = filePrefix + '/ave/'+subjID + '_AXCPTRun' + runNum + '.cov'
	print filename
	
	myFile = open(filename, "w")
	myFile.close()	
		
	myFile = open(filename, "a")
	myFile.write('cov {\n\n')
	myFile.write('\tname\t\"AXCPT\"\n\n')
	myFile.write('\toutfile\t\t'+subjID+ '_AXCPTRun' + runNum + '-cov.fif\n')
	myFile.write('\tlogfile\t\t./logs/'+subjID + '_AXCPTRun' + runNum +  '-cov.log\n')
	#myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_AXCPTRun' + runNum + '.eve\n\n')
	myFile.write('\teventfile\t'+filePrefix+'/eve/'+subjID+'_AXCPTRun' + runNum + 'Modblink.eve\n\n')
	myFile.write('\tgradReject\t'+gradRej + '\n\n')
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"AY\"\n')
	myFile.write('\t\tevent\t1\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')	
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"BX\"\n')
	myFile.write('\t\tevent\t2\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')	

	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"BY\"\n')
	myFile.write('\t\tevent\t3\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')	
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"AX\"\n')
	myFile.write('\t\tevent\t4\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')	
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"A\"\n')
	myFile.write('\t\tevent\t5\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')	
	
	myFile.write('\tcategory {\n')
	myFile.write('\t\tname\t\"B\"\n')
	myFile.write('\t\tevent\t6\n')
	myFile.write('\t\tignore\t0\n')
	myFile.write('\t\ttmin\t'+tMin+'\n')
	myFile.write('\t\ttmax\t-0.01\n')
	myFile.write('\t\tbmin\t'+tMin+'\n')
	myFile.write('\t\tbmax\t-.01\n\t}\n\n')	

	myFile.write('}\n')
	myFile.close()	