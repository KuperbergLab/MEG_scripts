import readInput
import writeOutput

subjList = ['ya1','ya2','ya3','ya4','ya5','ya6','ya7','ya8','ya9','ya12','ya13','ya15','ya16','ya17','ya18','ya19','ya20','ya21','ya23', 'ya24', 'ya25', 'ya26']

dataType = 'ave_projon'

dataPath = '/cluster/kuperberg/SemPrMM/MEG/data/'

##Masked##
runList = ['1','2']
condList = ['1','2','3']
allSubj = [['subj','C1','%','C2','%','C3','%']]

for subj in subjList:
	#print subj
	tempData = [subj]
	for cond in condList:
		totalCount = 0
		aveCount = 0
		
		for run in runList:
			inFile = dataPath+subj+'/'+dataType+'/logs/MaskedMMRun'+run+'ArtReject.txt';
			data=readInput.readTable(inFile)
	
			for row in data:
				if row[0] == cond: 
					totalCount = totalCount + int(row[1])
					aveCount = aveCount + int(row[2])
		percRem = str(round(float(aveCount)/float(totalCount)*100))+'%'
		tempData.append(aveCount)
		tempData.append( percRem )
	allSubj.append(tempData)

outFile = dataPath + 'ga/MaskedMM_ArtRej.txt';
writeOutput.writeTable(outFile, allSubj)



##Baleen##
runList = ['1','2','3','4','5','6','7','8']
condList = ['1','2','6','7']
allSubj = [['subj','C1','%','C2','%','C6','%','C7','%']]

for subj in subjList:
	tempData = [subj]
	for cond in condList:
		totalCount = 0
		aveCount = 0
		
		for run in runList:
			inFile = dataPath+subj+'/'+dataType+'/logs/BaleenRun'+run+'ArtReject.txt';
			data=readInput.readTable(inFile)
	
			for row in data:
				if row[0] == cond: 
					totalCount = totalCount + int(row[1])
					aveCount = aveCount + int(row[2])
		percRem = str(round(float(aveCount)/float(totalCount)*100))+'%'
		tempData.append(aveCount)
		tempData.append( percRem )
	allSubj.append(tempData)

outFile = dataPath + 'ga/Baleen_ArtRej.txt';
writeOutput.writeTable(outFile, allSubj)

print "hello"