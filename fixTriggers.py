import readInput
import writeOutput
import sys

subjID = sys.argv[1]

#ATLLOC

inFile = 'eve/' + subjID + '_ATLLoc.eve'
outFile = 'eve/' + subjID + '_ATLLocMod.eve'

print inFile
data = readInput.readTable(inFile)

dataSize = len(data)

wordCount = 0
flag = 0

firstRow = data[0]
firstSample = firstRow[0]
firstTime = firstRow[1]

for row in data:
	trigger = row[3]
	time = row[1]
	sampleRate = float(row[0])/float(row[1])
	trueSample = float(row[0]) + 19
	trueTime = trueSample/sampleRate
	row[0] = str(int(round(trueSample,0)))
	row[1] = str(round(trueTime,3))
	
	if trigger == '1' or trigger == '2' or trigger == '3':
		flag = trigger
		wordCount = 0
	else: wordCount +=1

	if trigger == '4' and wordCount <= 9:
		row[3] = trigger+flag
		

##Undo the timing change for the first row in file because this row indicates the beginning of the scan, not a visual event, so it shouldn't be changed

firstRow[0] = firstSample
firstRow[1] = firstTime

writeOutput.writeTable(outFile,data)

#BALEEN

RUNS = ['1', '2', '3', '4', '5', '6', '7', '8']

for x in RUNS:

	inFile = 'eve/'+subjID+'_BaleenRun'+x+'.eve'
	outFile = 'eve/'+subjID+'_BaleenRun'+x+'Mod.eve'
	
	print inFile
	data = readInput.readTable(inFile)
	
	firstRow = data[0]
	firstSample = firstRow[0]
	firstTime = firstRow[1]

	rowCount = 0
	for row in data:
		trigger = row[3]
		time = row[1]
		sampleRate = float(row[0])/float(row[1])
		trueSample = float(row[0]) + 19
		trueTime = trueSample/sampleRate
		row[0] = str(int(round(trueSample,0)))
		row[1] = str(round(trueTime,3))
		
		if trigger == '11' or trigger == '12':   ##change the target to '111' or '112'
			row[3] = '1'+trigger
			#print row
			
			for i in [1,2,3]:                 ## look through the previous three events to try to find the prime
				compRow = data[rowCount-i]
				#print 'Comparison', compRow

				compTrigger = compRow[3]
				compSOA = float(row[1])-float(compRow[1])
				if compTrigger == '14' and ( compSOA > .580 and compSOA < .620 ):  ##check for a prime with correct SOA
					compRow[3] = trigger
					#print 'new ', compRow, row
					break
			
		rowCount +=1
	
	##Undo the timing change for the first row in file because this row indicates the beginning of the scan, not a visual event, so it shouldn't be changed

	firstRow[0] = firstSample
	firstRow[1] = firstTime


	
	#SB moved this to end of biggest loop (otherwise writing file every row iteration)
	writeOutput.writeTable(outFile, data)

#SB	
###MaskedMM

RUNS = ['1','2']

for x in RUNS:

	inFile = 'eve/'+subjID+'_MaskedMMRun'+x+'.eve'
	outFile = 'eve/'+subjID+'_MaskedMMRun'+x+'Mod.eve'
	print inFile
	data = readInput.readTable(inFile)
	
	firstRow = data[0]
	firstSample = firstRow[0]
	firstTime = firstRow[1]

	
	for row in data:
		trigger = row[3]
		time = row[1]	
		sampleRate = float(row[0])/float(row[1])
		trueSample = float(row[0]) + 19
		trueTime = trueSample/sampleRate
		row[0] = str(int(round(trueSample,0)))
		row[1] = str(round(trueTime,3))


	##Undo the timing change for the first row in file because this row indicates the beginning of the scan, not a visual event, so it shouldn't be changed
		
	firstRow[0] = firstSample
	firstRow[1] = firstTime

	
	writeOutput.writeTable(outFile,data)


###AXCPT

RUNS = ['1','2']

if subjID == 'ya3':
	RUNS = ['1']


		
for x in RUNS:

	inFile = 'eve/'+subjID+'_AXCPTRun'+x+'.eve'
	outFile = 'eve/'+subjID+'_AXCPTRun'+x+'Mod.eve'
	print inFile
	data = readInput.readTable(inFile)
	
	###############################################################
	if subjID == 'ya6':  ####Fix error in triggers for this subject
		logFile = '../../vtsd_logs/ya6/AXCPT_ya6_List101_Run'+x+'.vtsd_log'
		print logFile
		logData = readInput.readTable(logFile)
		firstPrimeRow = data[2]
		firstPrimeTime = firstPrimeRow[1]		
		count = 0
		
		##Fix timing due to error in trigger coding
		for row in data:
			trueTime =  round(float(row[1]) - float(firstPrimeTime))
			if row[3] == '8':
				for logRow in logData:
					logTime = round(float(logRow[5])+1)
					if logTime == trueTime:
						#print logRow[5], logTime, trueTime, row[3], logRow[9]
						row[3] = logRow[9]
						#print logRow
	################################################################
	
	firstRow = data[0]
	firstSample = firstRow[0]
	firstTime = firstRow[1]

	rowCount = 0
	
	for row in data:
		trigger = row[3]
		time = row[1]	
		sampleRate = float(row[0])/float(row[1])
		trueSample = float(row[0]) + 19
		trueTime = trueSample/sampleRate
		row[0] = str(int(round(trueSample,0)))
		row[1] = str(round(trueTime,3))
		if len(data) > rowCount +1:
			nextRow = data[rowCount+1]
			nextTrigger = nextRow[3]
		else:
			break

		#############################################
		##change blinks triggered as 6 to 7s
		
		if trigger == '6':   
			if nextTrigger == '7':  
					row[3] = '7'
							
		###########################################
		##change triggers for incorrect trials#####
		
		##AX case
		if trigger == '4': 
			if len(nextTrigger) < 2:  ###Test for response (16, 32, 64 or 128)
				row[3] = '4' + trigger
				
		##BX, BY, AY case
		if (trigger == '1' or trigger == '2' or trigger == '3'):
			
			if len(nextTrigger) > 1:  ###Test for response (16, 32, 64 or 128)
				row[3] = '4' + trigger
		
		
		rowCount +=1
	
		

	##Undo the timing change for the first row in file because this row indicates the beginning of the scan, not a visual event, so it shouldn't be changed
		
	firstRow[0] = firstSample
	firstRow[1] = firstTime

	
	writeOutput.writeTable(outFile,data)
