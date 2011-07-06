function source_avgSTCinTimeAcrossSubjs(exp,condPair,type,norm,t1,t2)

sample1 = round(t1/1.6666 + 61);
sample2 = round(t2/1.6666 + 61);

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

if (strcmp(exp,'BaleenHP_All') || strcmp(exp,'BaleenLP_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/ya.baleen.meg.txt');
elseif (strcmp(exp,'MaskedMM_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/ya.masked.meg.txt');
end

subjList = subjList'

[~,n] = size(subjList);
 

for hemI = 1:2

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
 
        fileName = strcat(dataPath,subjDataPath,'ya',int2str(subj),'_',exp,'_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M-',type,'-',hem,'.stc')
        if norm == 1
            fileName = strcat(dataPath,subjDataPath,'ya',int2str(subj),'_',exp,'_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M-norm-',type,'-',hem,'.stc')
        end

        stcStruct = mne_read_stc_file(fileName);
        stcData = stcStruct.data;
        meanStcData = mean(stcData(:,sample1:sample2),2);

        outFile = strcat(dataPath,subjDataPath,'ya',int2str(subj),'_',exp,'_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M-',int2str(t1),'-',int2str(t2),'-',type,'-',hem,'.stc')
        if norm == 1
            outFile = strcat(dataPath,subjDataPath,'ya',int2str(subj),'_',exp,'_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M-norm-',int2str(t1),'-',int2str(t2),'-',type,'-',hem,'.stc')
        end

        newSTC = stcStruct;
        newSTC.data = meanStcData;

        mne_write_stc_file(outFile,newSTC);
    end
end