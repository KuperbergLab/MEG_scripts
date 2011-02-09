function saveSubjAve(exp, dataType, subjList)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

count = 0;
allSubjData={};


for subj=subjList
    count = count + 1;
    inFile = strcat(dataPath,'ya',int2str(subj),'/ave_',dataType,'/','ya',int2str(subj),'_',exp,'-ave.fif');
    tempSubjData = fiff_read_evoked_all(inFile);
    
    allSubjData{count} = tempSubjData;
    
end

outFile = strcat(dataPath, 'ga/ave_', dataType, '_',exp, '_n=',int2str(count));

save(outFile,'allSubjData')