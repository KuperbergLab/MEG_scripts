import sys
import os 
import os.path
import readInput
from operator import itemgetter, attrgetter

def computeEvents(subjType, par):
     data_path = '/cluster/kuperberg/SemPrMM/MEG/'
     outFile = data_path + 'results/artifact_rejection/megeeg_rejection/' + str(subjType) + '_MEEGArtRejSummary_' + str(par)
     myFile2 = open(outFile, "w") 

        
     if (subjType == 'ac'):
         subject_filename = data_path + 'scripts/function_inputs/ac.meg.all.txt'
     if (subjType == 'sc'):
         subject_filename = data_path + 'scripts/function_inputs/sc.meg.all.txt'
     if (subjType == 'ya'):
         subject_filename = data_path + 'scripts/function_inputs/ya.meg.all.txt'
     subject_list = readInput.readList(subject_filename)
     print subject_list

     for subject in subject_list:
  
#To Find the total number of rejected trials, and percentage inclusion
        subjID = str(subjType)+ str(subject)
        totalTrials = 0 # Must be initialised within the loop to refresh for each subject :) 
        totalRejects = 0
        trialCount=0
        rtrialCount=0
        pReject=0
        dataTable1=[]
        dataTable2=[]
        lineTemp = []
        lineTemp1 = []
        temp = 1
        
        inFile1 = data_path + 'data/' + str(subjID) + '/ave_projon/logs/' + str(subjID) + '_MEEGArtReject_' + str(par) 
        if os.path.exists(inFile1):
             
          myFile1 = open(inFile1, "r") 
          while temp:
             temp = myFile1.readline()
             temp1 = temp.strip() # when I included (' ') it did not return the items as a list, but when I just wrote () it did the trick!
             if temp1:
                temp2 = temp1.split()
                dataTable1.append(temp2) # Save information as a list of items in a DataTable
                runCount=len(dataTable1)   
          myFile1.close()
          
          for i in range(0, len(dataTable1)):
            lineTemp = (dataTable1[i])
            trialCount=float(lineTemp[0])
            rtrialCount=float(lineTemp[1])
            totalTrials = totalTrials + trialCount
            totalRejects = totalRejects + rtrialCount
            
          pReject=(1-round(((totalRejects)/float(totalTrials)),4))


# To Display the total number of rejected trials, and percentage         
          myFile2 = open(outFile, "a") 
          myFile2.write("\n")
          myFile2.write(subjID)
          myFile2.write("\n")
          myFile2.write("Number of events found:\t")
          myFile2.write(str(totalTrials))
          myFile2.write("\n")
          myFile2.write("Number of events rejected:\t")
          myFile2.write(str(totalRejects))
          myFile2.write("\n")
          myFile2.write("MEG/EEG Inclusion Rate:\t")
          myFile2.write(str(pReject))
          myFile2.write("\n")

# To Find the name of the bad channels rejected
          items=[]
          chans=[]
          chantot=[]
          temp3 = 1
          dataTable3=[]
          dataTable4=[]
          linetemp1=[]
          inFile2 = data_path + 'data/' + str(subjID) + '/ave_projon/logs/' + str(subjID) + '_MEEGArtReject-BadChan_' + str(par)
          myFile3 = open(inFile2, "r")
          while temp3:
             temp3 = myFile3.readline()
             temp4 = temp3.strip() 
             if temp4:
               temp5 = temp4.split()
               dataTable3.append(temp5) # Save information as a list of items in a DataTable
          for i in range(0, len(dataTable3)):
              lineTemp1 = dataTable3[i]
              chans.append(lineTemp1[0])
              chantot.append(lineTemp1[1])          
          items=list(set(chans))
          items = sorted(items, key=itemgetter(0)) # To print Gradiometer, magnetometers and theh the EEG channels in oreder. 
          

# To Display the name of the bad channels rejected
          myFile2.write("Number of Times MEG/EEG Channels Rejected")
          myFile2.write("\n")
          for i in range(0, len(items)):
                x=0
                myFile2.write(str(items[i]))
                for j in range(0, len(chans)):
                        if items[i] == chans[j]:
                              x = x + int(chantot[j])
                myFile2.write("\t")
                myFile2.write(str(x))
                myFile2.write("\n")
          myFile2.close()
          myFile3.close()

            
if __name__ == "__main__":
   
   computeEvents(sys.argv[1], sys.argv[2])
   

