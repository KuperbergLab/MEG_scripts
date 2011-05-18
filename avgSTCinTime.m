function avgSTCinTime(fileName,t1,t2)

sample1 = round(t1/1.6666 + 61);
sample2 = round(t2/1.6666 + 61);

stcStruct = mne_read_stc_file(fileName);
stcData = stcStruct.data;
meanStcData = mean(stcData(:,sample1:sample2),2);

outFile = strcat(fileName,int2str(t1),int2str(t2),'.stc');

newSTC = stcStruct;
newSTC.data = meanStcData;

mne_write_stc_file(outFile,newSTC);