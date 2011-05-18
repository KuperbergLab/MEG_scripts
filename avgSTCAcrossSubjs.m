function avgSTCAcrossSubjs(exp,condNum)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

if (strcmp(exp,'BaleenHP_All') || strcmp(exp,'BaleenLP_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.baleen.meg-mri.txt');
elseif (strcmp(exp,'MaskedMM_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.masked.meg-mri.txt');
end

subjList = subjList'
[~,n] = size(subjList);
%%for each subject, get the stc data out
for hemI = 1:2
    allSubjData = zeros(10242,480,n);

    if hemI == 1
        hem = 'lh';
    elseif hemI == 2
        hem = 'rh';
    end
    
    count = 0;
    for subj=subjList
        count=count+1;
        subj 
        subjDataPath = strcat('ya',int2str(subj),'/ave_projon/stc/');
        %%Read in stc file for subject

        filename = strcat(dataPath,subjDataPath,'ya',int2str(subj),'_',exp,'_c',int2str(condNum),'M-spm-',hem,'.stc')
        subjSTC = mne_read_stc_file(filename);
        subjData = subjSTC.data;

        allSubjData(:,:,count) = subjData;

    end
    size(allSubjData)
    gaSubjData = mean(allSubjData,3); %%

    newSTC = subjSTC;  %%just use the last subject's STC to get the structure of the file
    newSTC.data = gaSubjData;
    outFile = strcat(dataPath,'ga/ga_',exp,'_c',int2str(condNum),'M_n',int2str(n),'-spm-',hem,'.stc');
    mne_write_stc_file(outFile,newSTC);
    
end
    
