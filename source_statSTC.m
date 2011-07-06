function pArray = source_statSTC(exp,condPair,type,norm,numSamples)


dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

if (strcmp(exp,'BaleenHP_All') || strcmp(exp,'BaleenLP_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/ya.baleen.meg.txt');
elseif (strcmp(exp,'MaskedMM_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/ya.masked.meg.txt');
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
    allSubjData = zeros(10242,numSamples,n);

    %%for each subject, get the stc data out
    for subj=subjList
        count=count+1;
        subj


        %%Read in ave fif file for subject
        filename = strcat(dataPath,'ya',int2str(subj),'/ave_projon/stc/ya',int2str(subj),'_',exp, '_c',int2str(condPair(1)),'M-',type,'-lh.stc');
        subjRel = mne_read_stc_file(filename);

        filename = strcat(dataPath,'ya',int2str(subj),'/ave_projon/stc/ya',int2str(subj),'_',exp,'_c',int2str(condPair(2)),'M-',type,'-lh.stc');
        subjUnrel = mne_read_stc_file(filename);

        subjDiff = subjUnrel.data-subjRel.data;
        if norm == 1
             subjBaseline = mean(subjDiff(:,1:60),2);
             subjBaseline = repmat(subjBaseline,1,numSamples);
             subjSD = std(subjDiff(:,1:60),0,2);
             subjSD = repmat(subjSD,1,numSamples);
             subjDiff = (subjDiff-subjBaseline)./(subjSD);
        end
  

        allSubjData(:,:,count) = subjDiff;
        newSTC = subjRel;

    end

    size(allSubjData);

    pArray = zeros(10242,numSamples);    

    for y = 1:numSamples
        y
        [~,p] = ttest(squeeze(allSubjData(:,y,:))'); %%ttest works on first dimension of an array
        pArray(:,y) = p';
    end
    size(p)

    size(pArray)
    pArray = -log(pArray);
    
    newSTC.data = pArray;
    outFile = strcat(dataPath,'ga/stc/ga_',exp,'_diffSTC_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'_pVal_n',int2str(n),'-',type,'-',hem,'.stc');
    if norm == 1
        outFile = strcat(dataPath,'ga/stc/ga_',exp,'_diffSTC_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'_pVal_n',int2str(n),'-Norm-',type,'-',hem,'.stc');
    end
    mne_write_stc_file(outFile, newSTC);

end

