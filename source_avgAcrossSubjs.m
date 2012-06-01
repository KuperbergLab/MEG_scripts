function source_avgAcrossSubjs(exp,listPrefix,condNum,type,norm,numSamples)

%%type is spm or mne
%%norm is 0 or 1
%%if you pick mne and norm=1, you should end up with something basically identical to
%%spm

%%ex: source_avgAcrossSubjs('MaskedMM_All', '0007.meg.',1,'spm',0,481)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix,'.txt')))';
prefix = listPrefix([1:2])


[~,n] = size(subjList);
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
        subjDataPath = strcat(prefix,int2str(subj),'/ave_projon/stc/',exp,'/');
        %%Read in stc file for subject

        filename = strcat(dataPath,'data/',subjDataPath,prefix,int2str(subj),'_',exp,'_c',int2str(condNum),'M-',type,'-',hem,'.stc')
        subjSTC = mne_read_stc_file(filename);
        subjData = subjSTC.data;
        
        if norm == 1
            subjBaseline = mean(subjSTC.data(:,1:60),2);
            subjBaseline = repmat(subjBaseline,1,numSamples);
            subjSD = std(subjSTC.data(:,1:60),0,2);
            subjSD = repmat(subjSD,1,numSamples);
            subjSTC.data = (subjSTC.data-subjBaseline)./(subjSD);
        end
       
        allSubjData(:,:,count) = subjData;

    end
    size(allSubjData)
    gaSubjData = mean(allSubjData,3); %%

    newSTC = subjSTC;  %%just use the last subject's STC to get the structure of the file
    newSTC.data = gaSubjData;
    outFile = strcat(dataPath,'results/source_space/ga_stc/single_condition/ga_',listPrefix, '_',exp,'_c',int2str(condNum),'M-',type,'-',hem,'.stc');
    if norm==1
        outFile = strcat(dataPath,'results/source_space/ga_stc/single_condition/ga_',listPrefix, '_',exp,'_c',int2str(condNum),'M-norm-',type,'-',hem,'.stc');  
    end
    mne_write_stc_file(outFile,newSTC);
    
end
    
