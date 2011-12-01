import sys
import os 

def countBadChan(inFile, par):

        trialCount=rtrialCount = 0
        dataTable1=dataTable2=lineTemp=[]       
        myFile1 = open(inFile, "r") 
        temp = 1
        while temp:
           temp = myFile1.readline()
           temp1 = temp.strip() # when I included (' ') it did not return the items as a list, but when I just wrote () it did the trick!
           if temp1:
              temp2 = temp1.split()
              dataTable1.append(temp2) # Save information as a list of items in a DataTable
              trialCount=len(dataTable1)   
        myFile1.close()

        x=0
        chans=[]
        badchans=[] #initialise separately
        for i in range(0, trialCount):
            lineTemp = dataTable1[i]
            if len(lineTemp) > 10:
                rtrialCount +=1
                x = lineTemp.index("MEG")
                chans.append(lineTemp[x+1])
        items=list(set(chans)) #finds the items in a list(first occurances)
        for i in range(0, len(items)):
            badchans.append(items[i])
            badchans.append(chans.count(items[i]))
                            
        name1=str.split(str(inFile), '_')
        name2=str(name1[0]) + '_MEGArtReject' + str(par)
        outFile1=str(name2)
        myFile2 = open(outFile1, "a")
        myFile2.write("\n")
        myFile2.write(str(trialCount))
        myFile2.write("\t")
        myFile2.write(str(rtrialCount))
        myFile2.close()

        
        name3=str(name1[0]) + '_MEGArtReject-BadChan' + str(par)
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
