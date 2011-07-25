function source_avgSTCinTimeAcrossSubjs(exp,listPrefix,condPair,type,norm,t1,t2)

sample1 = round(t1/1.6666 + 61);
sample2 = round(t2/1.6666 + 61);

%%type is spm or mne
%%norm is 0 or 1
%%if you pick mne and norm=1, you should end up with something basically identical to
%%spm

%%You just use this if you want to create individual subject files for
%%time-windows so you can do stats across them.

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, exp, '.txt')))';



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
 
        fileName = strcat(dataPath,'data/',subjDataPath,'ya',int2str(subj),'_',exp,'_All_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M-',type,'-',hem,'.stc')
        if norm == 1
            fileName = strcat(dataPath,'data/',subjDataPath,'ya',int2str(subj),'_',exp,'_All_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M-norm-',type,'-',hem,'.stc')
        end

        stcStruct = mne_read_stc_file(fileName);
        stcData = stcStruct.data;
        meanStcData = mean(stcData(:,sample1:sample2),2);

        outFile = strcat(dataPath,'data/',subjDataPath,'ya',int2str(subj),'_',exp,'_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M-',int2str(t1),'-',int2str(t2),'-',type,'-',hem,'.stc')
        if norm == 1
            outFile = strcat(dataPath,'data/',subjDataPath,'ya',int2str(subj),'_',exp,'_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M-norm-',int2str(t1),'-',int2str(t2),'-',type,'-',hem,'.stc')
        end

        newSTC = stcStruct;
        newSTC.data = meanStcData;

        mne_write_stc_file(outFile,newSTC);
    end
end