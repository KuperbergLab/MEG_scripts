import readInput
import writeOutput
import sys
import os

def fixTriggers(subjID):    

    os.chdir("/cluster/kuperberg/SemPrMM/MEG/data/"+subjID)
    
    expList = ['ATLLoc','MaskedMM','BaleenLP','BaleenHP','AXCPT']
    
    runDict = { 'ATLLoc':[''],'MaskedMM':['Run1','Run2'],'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4'],'AXCPT':['Run1','Run2']}
    
    if subjID == 'ya3':
        runDict['AXCPT']=['Run1']

        
    if (subjID == 'ya1' or subjID == 'ya2' or subjID == 'ya4' or subjID == 'ya7' or subjID == 'ya8' or subjID == 'ya16'):
        runDict['AXCPT']=''
    
    print '----subject specific fixes'
    
        
        
    #########################
    ##FIX RANDOM YA19 ERROR
    ##This is only case where original .eve files gets changed, because somehow incorrect trigger got sent on a single trial (how could this happen? spooky)
    inFile= 'eve/ya19_BaleenLPRun2.eve'
    outFile = 'eve/ya19_BaleenLPRun2.eve'
    if os.path.exists(inFile):
    	data = readInput.readTable(inFile)
    	for row in data:
    		trigger = row[3]
    		time = row[1]
    		if (time == '162.257' and trigger == '2'):
    			print row
    			row[3] = 14
    			print row
    	writeOutput.writeTable(outFile,data)		

 
	###########################FIX RANDOM YA22 ERROR
    ##This is only case where original .eve files gets changed, because somehow incorrect trigger got sent on a single trial (how could this happen? spooky)
    inFile= 'eve/ya22_BaleenHPRun3.eve'
    outFile = 'eve/ya22_BaleenHPRun3.eve'
    if os.path.exists(inFile):
    	data = readInput.readTable(inFile)
    	for row in data:
    		trigger = row[3]
    		time = row[1]
    		if (time == '71.100' and trigger == '6'):
    			print row
    			row[3] = 14
    			print row
    	writeOutput.writeTable(outFile,data)		

    #########################
    ##FIX RANDOM YA6 ERROR
    ##This is only case where original .eve files gets changed, because somehow incorrect trigger got sent on a single trial (how could this happen? spooky)
    ##NOt clear what this code was originally so changing to 600
    inFile= 'eve/ya6_BaleenHPRun3.eve'
    outFile = 'eve/ya6_BaleenHPRun3.eve'
    if os.path.exists(inFile):
    	data = readInput.readTable(inFile)
    	for row in data:
    		trigger = row[3]
    		time = row[1]
    		if (time == '163.827' and trigger == '6'):
    			print row
    			row[3] = 600
    			print row
    		writeOutput.writeTable(outFile,data)
    		
    #########################
    ##FIX RANDOM YA16 MASKEDMM ERROR
    ##This is only case where original .eve files gets changed, because somehow incorrect trigger got sent on a single trial (how could this happen? spooky)
    inFile= 'eve/ya16_MaskedMMRun1.eve'
    outFile = 'eve/ya16_MaskedMMRun1.eve'
    if os.path.exists(inFile):
    	data = readInput.readTable(inFile)
    	for row in data:
    		trigger = row[3]
    		time = row[1]
    		if (time == '232.349' and trigger == '2'):
    			print row
    			row[3] = 3
    			print row
    	writeOutput.writeTable(outFile,data)	
    
	##########################
	##FIX UNKNOWN YA3 LPRUN3 ERROR
	#Although no documentation to explain, vtsd logs and raw datafiles show run3 restarted after one minute (54 events), so responses to the stimuli that had already been shown should not be counted. 
	
    inFile = 'eve/ya3_BaleenLPRun3.eve'
    outFile = 'eve/ya3_BaleenLPRun3.eve'
    if os.path.exists(inFile):
    	data = readInput.readTable(inFile)
    	for i in range(1,54):
    		row = data[i]
    		row[3] = int(row[3])+900
    	writeOutput.writeTable(outFile,data)	
    	
    	
	##########################
	##FIX YA24 MASKEDMMRUN1 LOSS OF DISPLAY ERROR
	#Scan log notes that MaskedMMRun1 was ended early because display got disconnected. This probably happened several seconds before presentation was ended. The last moment at which the subject responded was 316.707, so to be conservative we are removing triggers in the 16 subsequent seconds, in which the subject did not respond to several probe trials
	
    inFile= 'eve/ya24_MaskedMMRun1.eve'
    outFile = 'eve/ya24_MaskedMMRun1.eve'
    if os.path.exists(inFile):
    	data = readInput.readTable(inFile)
    	for row in data:
    		trigger = row[3]
    		time = row[1]
    		if (float(time) > 316.707):
    			row[3] = int(row[3])+900
    			print row
    	writeOutput.writeTable(outFile,data)	
	
    	
    	
    	
    	
    	
    	
    #########################
    ##FIX TIMING IN ALL SCRIPTS###
    print '----fix Timing'
    for exp in expList:
        for run in runDict[exp]:
                inFile = 'eve/' + subjID + '_'+exp+run+'.eve'
                outFile = 'eve/' + subjID + '_' + exp + run + 'Mod.eve'
                print inFile
                if os.path.exists(inFile):
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
                        trueSample = float(row[0]) + 19 ## compensate for the time lag between projector and trigger
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
        
        
    print '-----fix codes'    
    
        
        
    ###############################
    ###CHANGE CODES IN ATLLOC
    inFile = 'eve/' + subjID + '_ATLLocMod.eve'
    outFile = 'eve/' + subjID + '_ATLLocMod.eve'
    if os.path.exists(inFile):
        data = readInput.readTable(inFile)
        print inFile
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
    #MASKEDMM
    
    for x in runDict['MaskedMM']:
    	inFile = 'eve/'+subjID+'_MaskedMM'+x+'Mod.eve'
    	outFile = 'eve/'+subjID+'_MaskedMM'+x+'Mod.eve'
    	if os.path.exists(inFile):
    		data = readInput.readTable(inFile)
    		print inFile
    		
    		########################
    		##Change trigger for incorrect button presses ('go' responses)
    		rowCount = 0
    		for row in data:
    			trigger = row[3]
    			if (trigger == '1' or trigger == '2' or trigger == '3'):
    				nextRow = data[rowCount+1]
    				nextTrigger = nextRow[3]
    				#print 'hello', trigger, row, nextRow
    				if nextTrigger == '16' or nextTrigger == '32' or nextTrigger == '64' or nextTrigger == '128':
    					print "false positive: ", row, nextRow
    					row[3] = '500' + row[3]
    			rowCount +=1

    
    
    ###############################################
    #BALEENLP
    
    for x in runDict['BaleenLP']:
        inFile = 'eve/'+subjID+'_BaleenLP'+x+'Mod.eve'
        outFile = 'eve/'+subjID+'_BaleenLP'+x+'Mod.eve'
        if os.path.exists(inFile):
            data = readInput.readTable(inFile)
            print inFile
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
                
            ########################
            ##Change trigger for incorrect button presses ('go' responses)
            rowCount = 0
            for row in data:
                trigger = row[3]
                if (trigger == '1' or trigger == '2' or trigger == '4'):
                	nextRow = data[rowCount+1]
                	nextTrigger = nextRow[3]
                	#print row, nextRow
                	if nextTrigger == '16' or nextTrigger == '32' or nextTrigger == '64' or nextTrigger == '128':
                		print "false positive: ", row, nextRow
                		row[3] = '500' + row[3]
                rowCount +=1

            writeOutput.writeTable(outFile, data)

    ###############################################
    #BALEENHP
    
    for x in runDict['BaleenHP']:
        inFile = 'eve/'+subjID+'_BaleenHP'+x+'Mod.eve'
        outFile = 'eve/'+subjID+'_BaleenHP'+x+'Mod.eve'
        if os.path.exists(inFile):
            data = readInput.readTable(inFile)
            print inFile
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
                    
                ##Flip half of the related filler triggers to '18' to get equal number of related and unrelated
                if trigger == '8':
                    if flag2 == 1:
                        row[3] = '18'
                        flag2 = 0
                    elif flag2 == 0:
                        flag2 = 1   
                                            
                rowCount +=1          
            
            ########################
            ##Change trigger for incorrect button presses ('go' responses)
            rowCount = 0
            for row in data:
                trigger = row[3]

                if (trigger == '6' or trigger == '7' or trigger == '8' or trigger == '9' or trigger == '18'):
                	nextRow = data[rowCount+1]
                	nextTrigger = nextRow[3]
                	#print row, nextRow
                	if nextTrigger == '16' or nextTrigger == '32' or nextTrigger == '64' or nextTrigger == '128':
                		print "false positive: ", row, nextRow
                		row[3] = '500' + row[3]
                rowCount +=1
                		
                            
            ##########################################write it all out    
            writeOutput.writeTable(outFile, data)


    #########################   
    ###AXCPT
            
    for x in runDict['AXCPT']:
        x
        inFile = 'eve/'+subjID+'_AXCPT'+x+'Mod.eve'
        outFile = 'eve/'+subjID+'_AXCPT'+x+'Mod.eve'
        if os.path.exists(inFile):
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
                # if trigger == '4': 
#                     if len(nextTrigger) < 2:  ###Test for response (16, 32, 64 or 128)
#                         row[3] = '4' + trigger
                        
                ##BX, BY, AY case
#                 if (trigger == '1' or trigger == '2' or trigger == '3'):
#                     
#                     if len(nextTrigger) > 1:  ###Test for response (16, 32, 64 or 128)
#                         row[3] = '4' + trigger
#                             
                rowCount +=1
            
            
            writeOutput.writeTable(outFile,data)
        
if __name__ == "__main__":
    subjID = sys.argv[1]
    fixTriggers(subjID)
