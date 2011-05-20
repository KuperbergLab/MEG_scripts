import readInput
import writeOutput
import sys
import os

def fixTriggers(subjID):	

	os.chdir("/cluster/kuperberg/SemPrMM/MEG/data/"+subjID)
	
	expList = ['ATLLoc','MaskedMM','BaleenLP','BaleenHP','AXCPT']
	
	runDict = {'ATLLoc':[''],'MaskedMM':['Run1','Run2'],'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4'],'AXCPT':['Run1','Run2']}
	
	if subjID == 'ya3':
		runDict['AXCPT']=['Run1']

		
	if (subjID == 'ya1' or subjID == 'ya2' or subjID == 'ya4' or subjID == 'ya7' or subjID == 'ya8' or subjID == 'ya16'):
		runDict['AXCPT']=''
		
	#########################
	##FIX TIMING IN ALL SCRIPTS###
	
	for exp in expList:
		for run in runDict[exp]:
				inFile = 'eve/' + subjID + '_'+exp+run+'.eve'
				outFile = 'eve/' + subjID + '_' + exp + run + 'Mod.eve'
				print inFile
				data = readInput.readTable(inFile)
				
				firstRow = data[0]
				firstSample = firstRow[0]
				firstTime = firstRow[1]
				
				wordCount = 0   ##for ATLLoc
				flag = ''
				
				for row in data:
					trigger = row[3]
					time = row[1]	
					sampleRate = float(row[0])/float(row[1])
					trueSample = float(row[0]) + 19
					trueTime = trueSample/sampleRate
					row[0] = str(int(round(trueSample,0)))
					row[1] = str(round(trueTime,3))
					finalRow = row
			
				##Undo the timing change for the first row in file because this row indicates the beginning of the scan, not a visual event, so it shouldn't be changed
					
				firstRow[0] = firstSample
				firstRow[1] = firstTime

				###add extra trigger to get around MNE bug that ignores last row
				extraRow = [str(int(finalRow[0])+1),str(round(float(finalRow[1])+1,3)),'0','99']
				data.append(extraRow)
				writeOutput.writeTable(outFile,data)
				
	###############################
	###CHANGE CODES IN ATLLOC
	inFile = 'eve/' + subjID + '_ATLLocMod.eve'
	outFile = 'eve/' + subjID + '_ATLLocMod.eve'
	data = readInput.readTable(inFile)

	wordCount = 0
	flag = ''
	
	for row in data:
		trigger = row[3]

		if trigger == '1' or trigger == '2' or trigger == '3':
			flag = trigger
			wordCount = 0
		else: wordCount +=1
	
		if trigger == '4' and wordCount <= 9:
			row[3] = trigger+flag
	
	writeOutput.writeTable(outFile,data)
	
	
	###############################################
	#BALEENLP
	
	for x in runDict['BaleenLP']:
		inFile = 'eve/'+subjID+'_BaleenLP'+x+'Mod.eve'
		outFile = 'eve/'+subjID+'_BaleenLP'+x+'Mod.eve'
		data = readInput.readTable(inFile)		
		rowCount = 0
		for row in data:
			trigger = row[3]
			
			##This part fixes the coding for the probe primes. Originally the trigger 11 was sent for the target when the prime was a probe. This recodes the target as 111 and codes the prime itself as 11
			if trigger == '11':   ##change the target to '111'
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

		writeOutput.writeTable(outFile, data)


	###############################################
	#BALEENHP
	
	for x in runDict['BaleenHP']:
		inFile = 'eve/'+subjID+'_BaleenHP'+x+'Mod.eve'
		outFile = 'eve/'+subjID+'_BaleenHP'+x+'Mod.eve'
		data = readInput.readTable(inFile)
		
		rowCount = 0
		flag2 = 0
		for row in data:
			trigger = row[3]
			
			if trigger == '12':   ##change the target to '112'
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
				
			##Flip half of the related filler triggers to '88' to get equal number of related and unrelated
			if trigger == '8':
				if flag2 == 1:
					row[3] = '88'
					flag2 = 0
				elif flag2 == 0:
					flag2 = 1	
				
			rowCount +=1
		
		writeOutput.writeTable(outFile, data)


	#########################	
	###AXCPT
			
	for x in runDict['AXCPT']:
		x
		inFile = 'eve/'+subjID+'_AXCPT'+x+'Mod.eve'
		outFile = 'eve/'+subjID+'_AXCPT'+x+'Mod.eve'
		data = readInput.readTable(inFile)
		
		###############################################################
		if subjID == 'ya6':  ####Fix error in triggers for this subject
			logFile = '../../vtsd_logs/ya6/AXCPT_ya6_List101_'+x+'.vtsd_log'
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

		rowCount = 0
		
		for row in data:
			trigger = row[3]
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
		
		
		writeOutput.writeTable(outFile,data)
		
if __name__ == "__main__":
	subjID = sys.argv[1]
	fixTriggers(subjID)
