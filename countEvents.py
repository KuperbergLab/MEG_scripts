import readInput
import writeOutput
import sys

##Usage: python countEvents.py subjNum magRej task numRuns


def countEvents(subjNum,magRej,task,numRuns,dataType):
	##File containing the original number of events recorded
	allEveFileName = "/cluster/kuperberg/SemPrMM/MEG/data/" + subjNum + '/eve/' + subjNum + '_' + task + 'Mod.eve'
	
	##File containing the number of events recorded after blink rejection through preProc3
	filePrefix = "/cluster/kuperberg/SemPrMM/MEG/data/" + subjNum + "/ave_"+dataType+"/logs/"
	fileName = filePrefix + subjNum + '_' + task +  "-ave.log"
	
	##File that will contain output table
	outFile = filePrefix + subjNum + '_' + task + "ArtReject.txt"
	
	##Defining triggers to count for each task
	TASKS = {"Blink" : ('1'), "ATLLoc" : ('1','2','3','41','42','43'), "MaskedMM" : ('1','2', '3', '4', '5', '14'), "Baleen" : ('1', '2', '3','4','5','6','7','8','9','10','11','12','14'), "AX-CPT" : ('1', '2', '3', '4', '5', '6')}
	
	
	for i in range(int(numRuns)):
	
		trigCounts = []
		
		if int(numRuns) > 1: 
			fileName = filePrefix + subjNum + '_' + task + "Run" + str(i+1) + "-ave.log"
			allEveFileName = "/cluster/kuperberg/SemPrMM/MEG/data/" + subjNum + '/eve/' + subjNum + '_' + task + 'Run' + str(i+1) + 'Mod.eve'
			outFile = filePrefix + task + "Run" + str(i+1) + "ArtReject.txt"
		
	
		print "\nCounting events from ", fileName
		
		print "\nSubject", subjNum, task
		print "MagReject", magRej
		
		eveAll = readInput.readTable(allEveFileName)
		eveBlink = readInput.readTable(fileName)
		currTrigs = TASKS[task]
		
		for trigger in currTrigs:
			temp = [trigger, 0, 0]
		
			for row in eveAll:
				if row[3] == trigger: 
					temp[1] +=1
					
			for row in eveBlink:
				if row[3] == trigger: 
					temp[2] +=1
			
			trigCounts.append(temp)
		
		print "Trigger\t","Total\t","ArtRej","% Remaining"
	
		myFile = open(outFile, "w")
		
		myFile.write("SubjectID: ")
		myFile.write(subjNum)
		myFile.write("\nTrigger\tTotal\tArtRej\t% Remaining\n")
	
		
		for row in trigCounts:
			prop = 0
			if int(row[1]) <> 0: prop = round(float(row[2])/float(row[1]),2)
			print row[0],"\t",row[1],"\t",row[2], "\t", prop
			myFile.write(row[0])
			myFile.write("\t")
			myFile.write(str(row[1]))
			myFile.write("\t")
			myFile.write(str(row[2]))
			myFile.write("\t")
			myFile.write(str(prop))
			myFile.write("\n")
		print
		
		
		myFile.close()
	

if __name__ == "__main__":
	subjNum = sys.argv[1]
	magRej = sys.argv[2]
	task = sys.argv[3]
	numRuns = sys.argv[4]
	dataType = sys.argv[5]
	countEvents(subjNum,magRej,task,numRuns,dataType)