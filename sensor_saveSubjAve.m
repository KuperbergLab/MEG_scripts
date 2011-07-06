function sensor_saveSubjAve(exp)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

for x = 1:2
    if x == 1
        projType = 'projoff';
        dataType = 'eeg';
    else
        projType = 'projon';
        dataType = 'meg';
    end

    
    if (strcmp(exp,'BaleenHP_All') || strcmp(exp,'BaleenLP_All'))
        subjList = dlmread(strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/ya.baleen.',dataType,'.txt'));
    elseif (strcmp(exp,'MaskedMM_All'))
        subjList = dlmread(strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/ya.masked.',datatype,'.txt'));
    end
    subjList = subjList'
    
    count = 0;
    allSubjData={};

    for subj=subjList
        count = count + 1;
        inFile = strcat(dataPath,'ya',int2str(subj),'/ave_',projType,'/','ya',int2str(subj),'_',exp,'-ave.fif');
        tempSubjData = fiff_read_evoked_all(inFile);

        allSubjData{count} = tempSubjData;

    end

    outFile = strcat(dataPath, 'ga/mat/ave_', projType, '_',exp, '_n=',int2str(count));

    save(outFile,'allSubjData')
end