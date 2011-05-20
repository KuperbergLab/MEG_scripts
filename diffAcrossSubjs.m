function dataStruct = diffAcrossSubjs(gafif, cond1, cond2)

%%This function takes as input a grand-average fif file and 
%%creates a new one containing the difference between two
%%conditions. 


%%%Selecting data path and subject%%%%

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/ga/';

dataStruct = fiff_read_evoked_all(strcat(dataPath,gafif,'.fif'));

[~,nCond] = size(dataStruct.evoked)

data1 = dataStruct.evoked(cond1).epochs;
data2 = dataStruct.evoked(cond2).epochs;

diffData = data2-data1;

dataStruct.evoked(nCond+1) = dataStruct.evoked(cond1);
dataStruct.evoked(nCond+1).epochs = diffData;
dataStruct.evoked(nCond+1).comment = strcat('diff_',dataStruct.evoked(cond2).comment,'-',dataStruct.evoked(cond1).comment);
dataStruct.evoked(nCond+1).nave = 1;

outFile = strcat(dataPath,gafif,'_sdiff_',int2str(cond2),'-',int2str(cond1),'.fif');
fiff_write_evoked(outFile,dataStruct);