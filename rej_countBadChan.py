import sys
import os 
import readInput

#This script is called by MEEGArtReject.sh
#The MEEGArtReject_ file contains the total number of specified triggers encountered by MNE and the number rejected
#The MEEGArtReject-BadChan file contains a list of channels that caused rejection and the # of trials rejected
#These are fed into MEEGArtReject.sh

def countBadChan(inFile, par):
        
        trialCount= 0
        rtrialCount = 0
        badTrials=[]
        badchans=[] #initialise separately
        items=[]
        dataTable = []
        
        dataTable = readInput.readTable(inFile)
        trialCount=len(dataTable)
        #print trialCount
        
        # read through the output logfile from the MNE averaging and look for longer lines indicating rejection
        # lines that have more than 9 columns are epochs that were rejected
        # if you count over 8 from the right, you will get the channel number that caused the rejection
       	for row in dataTable:
             if len(row) > 10:
                     badTrials.append(row[len(row) - 8]) #append the last but 8th item in the list-lineTemp to chans
                     rtrialCount+=1
    	badChanList=list(set(badTrials)) #finds the items in a list(first occurances)
    	#print(list(badTrials))
    	
    	##Create critical data table of bad channels and the number of trials they caused rejection
    	for chan in badChanList:
    		badchans.append([chan, badTrials.count((chan))])
    	#print(badchans)	
                                    
        name1=str.split(str(inFile), '_')
        name2=str(name1[0]) + '_MEEGArtReject_' + str(par)
        outFile1=str(name2)
        myFile2 = open(outFile1, "a")
        myFile2.write("\n")
        myFile2.write(str(trialCount))
        myFile2.write("\t")
        myFile2.write(str(rtrialCount))
        myFile2.close()

        name3=str(name1[0]) + '_MEEGArtReject-BadChan_' + str(par)
        outFile2=str(name3)
        myFile3 = open(outFile2, "a")
        for row in badchans:
            myFile3.write("\n")
            myFile3.write(row[0])
            myFile3.write("\t")
            myFile3.write(str(row[1]))
            myFile3.write("\n")
        myFile3.close()

if __name__ == "__main__":
   
   countBadChan(sys.argv[1], sys.argv[2])
