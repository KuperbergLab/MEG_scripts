import sys
import os 
import readInput

def countBadChan(inFile, par):
        
        trialCount= 0
        rtrialCount = 0
        chans=[]
        badchans=[] #initialise separately
        items=[]
        dataTable = []
        
        dataTable = readInput.readTable(inFile)
        trialCount=len(dataTable)
        
        # read through the output logfile from the MNE averaging and look for longer lines indicating rejection
        # lines that have more than 9 columns are epochs that were rejected
        # if you count over 8 from the right, you will get the channel number that caused the rejection
       	for row in dataTable:
             if len(row) > 10:
                     chans.append(row[len(row) - 8]) #append the last but 8th item in the list-lineTemp to chans
                     rtrialCount+=1
    	items=list(set(chans)) #finds the items in a list(first occurances)
        
        for i in range(0, len(items)):
            badchans.append(items[i])
            badchans.append(chans.count(items[i]))
                            
        name1=str.split(str(inFile), '_')
        name2=str(name1[0]) + '_MEEGArtReject_' + str(par)
        outFile1=str(name2)
        myFile2 = open(outFile1, "w")
        myFile2.write("\n")
        myFile2.write(str(trialCount))
        myFile2.write("\t")
        myFile2.write(str(rtrialCount))
        myFile2.close()

        name3=str(name1[0]) + '_MEEGArtReject-BadChan_' + str(par)
        outFile2=str(name3)
        myFile3 = open(outFile2, "w")
        for i in range(0, len(badchans), 2):
            myFile3.write("\n")
            myFile3.write(str(badchans[i]))
            myFile3.write("\t")
            myFile3.write(str(badchans[i+1]))
            myFile3.write("\n")
        myFile3.close()

if __name__ == "__main__":
   
   countBadChan(sys.argv[1], sys.argv[2])
