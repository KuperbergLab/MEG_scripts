function saveSubjAve(exp)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

if (strcmp(exp,'BaleenHP_All') || strcmp(exp,'BaleenLP_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.baleen.meg-mri.txt');
elseif (strcmp(exp,'MaskedMM_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.masked.meg-mri.txt');
end

subjList = subjList'

for x = 1:2
    if x == 1
        dataType = 'projoff';
    else
        dataType = 'projon';
    end

    count = 0;
    allSubjData={};

    for subj=subjList
        count = count + 1;
        inFile = strcat(dataPath,'ya',int2str(subj),'/ave_',dataType,'/','ya',int2str(subj),'_',exp,'-ave.fif');
        tempSubjData = fiff_read_evoked_all(inFile);

        allSubjData{count} = tempSubjData;

    end

    outFile = strcat(dataPath, 'ga/mat/ave_', dataType, '_',exp, '_n=',int2str(count));

    save(outFile,'allSubjData')
end