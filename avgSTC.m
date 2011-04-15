function avgSTC(task,subjList,condList)

%%This averages STC movies across runs of a single subject

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/ya';

if strcmp(task,'MaskedMM')
    runV = 1:2;
    exp = task;
elseif strcmp(task,'BaleenLP')
    runV = 1:4;
    exp = 'Baleen';
elseif strcmp(task,'BaleenHP')
    runV = 5:8;
    exp = 'Baleen';

end


for subj=subjList
    
    for x = condList
 
        tempL = [];
        tempR = [];
        allL = [];
        allR = [];
        
        count = 0;
        for y = runV
            count = count +1;
            %%Read in ave fif file for subject
            filenameL = strcat(dataPath,int2str(subj),'/ave_projon/stc/ya',int2str(subj),'_',exp,'Run',int2str(y),'_c',int2str(x),'-spm-lh.stc')
            tempL = mne_read_stc_file(filenameL);
            filenameR = strcat(dataPath,int2str(subj),'/ave_projon/stc/ya',int2str(subj),'_',exp,'Run',int2str(y),'_c',int2str(x),'-spm-rh.stc')
            tempR = mne_read_stc_file(filenameR);
           
            %%add data to array
            allL(:,:,count) = tempL.data;
            allR(:,:,count) = tempR.data;
            
            %%create separate holding array to write result into
            blankSTCL = tempL;
            blankSTCR = tempR;

        end
        
        allL(1,1,1:4)
        test = blankSTCL;
        
        %%Take the mean across runs
        avgL = mean(allL,3);
        avgR = mean(allR,3);
        avgL(1,1)
        %%Write it to the data field of the holding array
        blankSTCL.data = avgL;
        blankSTCR.data = avgR;
        %%The file name for the new STC files
        outfileL = strcat(dataPath,int2str(subj),'/ave_projon/stc/ya',int2str(subj),'_',task,'_All','_c',int2str(x),'-spm-lh.stc')
        outfileR = strcat(dataPath,int2str(subj),'/ave_projon/stc/ya',int2str(subj),'_',task,'_All','_c',int2str(x),'-spm-rh.stc')
        %%Write out to stc
        mne_write_stc_file(outfileL, blankSTCL);
        mne_write_stc_file(outfileR,blankSTCR);
        
    end
    
end
    
end