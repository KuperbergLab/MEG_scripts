function source_diffEachSubj(exp,listPrefix,condPair,type,norm, numSamples)

%%type is spm or mne
%%norm is 0 or 1
%%if you pick mne and norm=1, you should end up with something basically identical to
%%spm

%%ex: source_diffEachSubj('MaskedMM_All','ya.meg.',[1 3],'spm',0,480)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';



[~,n] = size(subjList);
n
%%for each subject, get the stc data out
for hemI = 1:2
    allSubjData = zeros(10242,numSamples,n);

    if hemI == 1
        hem = 'lh';
    elseif hemI == 2
        hem = 'rh';
    end
    
    count = 0;
    for subj=subjList
        count=count+1;
        subj 
        subjDataPath = strcat('ya',int2str(subj),'/ave_projon/stc/',exp,'/');
        %%Read in stc file for subject

        for c = 1:2
            filename = strcat(dataPath,'data/',subjDataPath,'ya',int2str(subj),'_',exp,'_c',int2str(condPair(c)),'M-',type,'-',hem,'.stc')
            
            subjSTC = mne_read_stc_file(filename);
            
            if norm == 1
                subjBaseline = mean(subjSTC.data(:,1:60),2);
                subjBaseline = repmat(subjBaseline,1,numSamples);
                subjSD = std(subjSTC.data(:,1:60),0,2);
                subjSD = repmat(subjSD,1,numSamples);
                subjSTC.data = (subjSTC.data-subjBaseline)./(subjSD);
            end
            
            subjData(:,:,c) = subjSTC.data;
                     
        end
        
        subjDataDiff = subjData(:,:,2)-subjData(:,:,1);
        
        outFile = strcat(dataPath,'data/',subjDataPath,'ya',int2str(subj),'_',exp,'_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M-',type,'-',hem,'.stc')
        if norm == 1
            outFile = strcat(dataPath,'data/',subjDataPath,'ya',int2str(subj),'_',exp,'_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M-norm-',type,'-',hem,'.stc')
        end
        newSTC = subjSTC;
        newSTC.data = subjDataDiff;
        mne_write_stc_file(outFile,newSTC);
        
        %%Grand-average structure
        allSubjData(:,:,count) = subjDataDiff;

    end
    
    size(allSubjData)
    gaSubjData = mean(allSubjData,3); %%

    newSTC = subjSTC;  %%just use the last subject's STC to get the structure of the file
    newSTC.data = gaSubjData;
    outFile = strcat(dataPath,'results/source_space/ga_stc/diff/ga_',listPrefix,'_',exp,'_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M','-',type,'-',hem,'.stc');
    
    if norm == 1
          outFile = strcat(dataPath,'results/source_space/ga_stc/diff/ga_',listPrefix,'_',exp,'_c',int2str(condPair(2)),'-c',int2str(condPair(1)),'M-norm','-',type,'-',hem,'.stc');  
    end
    
    mne_write_stc_file(outFile,newSTC);
    
end
    
