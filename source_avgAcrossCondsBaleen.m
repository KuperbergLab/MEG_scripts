function source_avgAcrossCondsBaleen(listPrefix,type)

%%This script averages the grand-average STCs across the 4 key Baleen
%%conditions: LP Related, LP Unrelated, HP Related, HP Unrelated

dataPath = '/cluster/kuperberg/SemPrMM/MEG/results/source_space/ga_stc/single_condition/'

for hemI = 1:2  %%Separate STC files output for each hemisphere
    
    if hemI == 1
        hem = 'lh';
    elseif hemI == 2
        hem = 'rh';
    end
    
    count = 0;
    for expI = 1:2
        
        if expI == 1
            exp = 'BaleenLP_All'
        elseif expI == 2
            exp = 'BaleenHP_All'
        end
        
        for cond = 1:2
            count = count +1;
            fileName = strcat(dataPath,'ga_',listPrefix, '_',exp,'_c',int2str(cond),'M-',type,'-',hem,'.stc')
            stcStruct = mne_read_stc_file(fileName);
            stcData = stcStruct.data;
            stcDataAll(:,:,count) = stcData;  %%put all stc matrices into one big 3D array
        end
    end

    size(stcDataAll)
    stcDataMean = mean(stcDataAll,3); %%Take mean across condition dimension
    size(stcDataMean)
        
    outFile = strcat(dataPath,'ga_',listPrefix,'_AllCondBaleen-',type,'-',hem,'.stc');
    newSTC = stcStruct;
    newSTC.data = stcDataMean;
    mne_write_stc_file(outFile,newSTC);
end


end