function pArray = source_statSTCTime(exp,listPrefix,condPair,type,norm,numSamples,t1,t2)

%%Be careful: usually numSamples should be set to 1
%%ex:source_statSTCTime('MaskedMM_All','ya.meg.',[1 3],'spm',0,1,350,450);

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix,  '.txt')))';
prefix = listPrefix([1:2]);


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
       subjDataPath = strcat(prefix,int2str(subj),'/ave_projon/stc/',exp,'/');
 
       fileName = strcat(dataPath,'data/',subjDataPath,prefix,int2str(subj),'_',exp,'_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M_',int2str(t1),'-',int2str(t2),'-',type,'-',hem,'.stc')
       subjStruct = mne_read_stc_file(fileName);

        subjDiff = subjStruct.data;

        if norm == 1
             subjBaseline = mean(subjDiff(:,1:60),2);
             subjBaseline = repmat(subjBaseline,1,numSamples);
             subjSD = std(subjDiff(:,1:60),0,2);
             subjSD = repmat(subjSD,1,numSamples);
             subjDiff = (subjDiff-subjBaseline)./(subjSD);
        end
  
        size(subjDiff)
        allSubjData(:,:,count) = subjDiff;
        newSTC = subjStruct;

    end

    size(allSubjData);

    pArray = zeros(10242,numSamples);    

    for y = 1:numSamples
        y;
        [~,p,~,stats] = ttest(squeeze(allSubjData(:,y,:))'); %%ttest works on first dimension of an array
        pArray(:,y) = p';
        tArray(:,y) = (stats.tstat)';
 
    end
    size(p)

    size(pArray)
    pArray = -log10(pArray);
    
    newSTC.data = pArray;
    outFile = strcat(dataPath,'results/source_space/ga_stc_logp_map/ga_',listPrefix,'_',exp,'_diffSTC_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'_pVal_n',int2str(n),'_',int2str(t1),'-',int2str(t2),'-',type,'-',hem,'.stc');
    if norm == 1
        outFile = strcat(dataPath,'results/source_space/ga_stc_logp_map/ga_',listPrefix,'_',exp,'_diffSTC_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'_pVal_n',int2str(n),'-Norm-',type,'-',hem,'.stc');
    end
    mne_write_stc_file(outFile, newSTC);
    
    
        newSTC.data = tArray;
    newSTC.data(1,1);
    outFile = strcat(dataPath,'results/source_space/ga_stc_t_map/ga_',listPrefix, '_',exp,'_diffSTC_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'_t-',int2str(t1),'-',int2str(t2),'-',type,'-',hem,'.stc');
    if norm == 1
       outFile = strcat(dataPath,'results/source_space/ga_stc_t_map/ga_',listPrefix,'_',exp,'_diffSTC_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'_t-Norm-',int2str(t1),'-',int2str(t2),'-',type,'-',hem,'.stc');
    end
    mne_write_stc_file(outFile, newSTC);


end

