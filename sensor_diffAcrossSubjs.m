function dataStruct = sensor_diffAcrossSubjs(gafif, cond1, cond2)

%%This function takes as input a grand-average fif file and 
%%adds an average for the difference between two
%%conditions. 


%%%Selecting data path and subject%%%%

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/ga/';
fileName = strcat(dataPath,gafif)

dataStruct = fiff_read_evoked_all(fileName);

[~,nCond] = size(dataStruct.evoked)

data1 = dataStruct.evoked(cond1).epochs;
data2 = dataStruct.evoked(cond2).epochs;

diffData = data2-data1;

dataStruct.evoked(nCond+1) = dataStruct.evoked(cond1);
dataStruct.evoked(nCond+1).epochs = diffData;
dataStruct.evoked(nCond+1).comment = strcat('diff_',dataStruct.evoked(cond2).comment,'-',dataStruct.evoked(cond1).comment);
dataStruct.evoked(nCond+1).nave = 1;

fiff_write_evoked(fileName,dataStruct);