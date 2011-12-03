function dataStruct = sensor_diffEachSubj(exp, subjGroup, listPrefix, cond1, cond2)

%%This function computes a difference event for each subject's average

%%Be careful, every time you run it, it will add another event to the
%%-ave.fif file for each subj!

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';


%%%Selecting data path and subject%%%%

for subj=subjList

    fileName = strcat(dataPath,'data/',subjGroup,int2str(subj),'/ave_projon/',subjGroup,int2str(subj),'_',exp,'-ave.fif');
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
end