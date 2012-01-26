import sys
import os 

def countBadChan(inFile, par):
        
        trialCount=rtrialCount = 0
        lineTemp=[]
        rlineTemp=[]
        x=0
        chans=[]
        badchans=[] #initialise separately
        items=[]
        temp = 1
        dataTable = []
        
        myFile = open(inFile, "r")
        while temp:
            temp = myFile.readline()
            temp = temp.strip('] ')
            temp = temp.split()
            if temp:
                dataTable.append(temp)
        myFile.close()
        trialCount=len(dataTable)
        
        for i in range(0, trialCount):
            lineTemp = dataTable[i]
            if len(lineTemp) > 10:
                    chans.append(lineTemp[len(lineTemp) - 8]) #append the last but 8th item in the list-lineTemp to chans
                    rtrialCount+=1
        items=list(set(chans)) #finds the items in a list(first occurances)
        
        for i in range(0, len(items)):
            badchans.append(items[i])
            badchans.append(chans.count(items[i]))
                            
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
        for i in range(0, len(badchans), 2):
            myFile3.write("\n")
            myFile3.write(str(badchans[i]))
            myFile3.write("\t")
            myFile3.write(str(badchans[i+1]))
            myFile3.write("\n")
        myFile3.close()

if __name__ == "__main__":
   
   countBadChan(sys.argv[1], sys.argv[2])
