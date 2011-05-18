function pArray = statSTC

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

exp = 'BaleenHP_All';

if (strcmp(exp,'BaleenHP_All') || strcmp(exp,'BaleenLP_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.baleen.meg-mri.txt');
elseif (strcmp(exp,'MaskedMM_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.masked.meg-mri.txt');
end
subjList = subjList'

for hemI = 1:2
    
    if hemI == 1
        hem = 'lh';
    elseif hemI == 2
        hem = 'rh';
    end

    count = 0;
    [~,n] = size(subjList);
    allSubjData = zeros(10242,480,n);

    %%for each subject, get the stc data out
    for subj=subjList
        count=count+1;
        subj


        %%Read in ave fif file for subject
        filename = strcat(dataPath,'ya',int2str(subj),'/ave_projon/stc/ya',int2str(subj),'_BaleenHP_All_c1M-spm-lh.stc');
        subjRel = mne_read_stc_file(filename);

        filename = strcat(dataPath,'ya',int2str(subj),'/ave_projon/stc/ya',int2str(subj),'_BaleenHP_All_c2M-spm-lh.stc');
        subjUnrel = mne_read_stc_file(filename);

        subjDiff = subjUnrel.data-subjRel.data;

        allSubjData(:,:,count) = subjDiff;
        newSTC = subjRel;

    end

    size(allSubjData)

    pArray = zeros(10242,480);

    for x = 1:10%242
        x
        for y = 1:480
            [~,p] = ttest(squeeze(allSubjData(x,y,:)));
            pArray(x,y) = -log(p);
        end
    end

    newSTC.data = pArray;
    outFile = strcat(dataPath,'ga/ga_',exp,'_diffSTC_pVal_n',int2str(n),'-spm-',hem,'.stc');
    mne_write_stc_file(outFile, newSTC);

end

