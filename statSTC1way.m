function pArray = statSTC1way(subjList,exp,condNum)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';
[~,n] = size(subjList);
%%for each subject, get the stc data out
for hemI = 1
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

        allSubjData(:,:,count) = subjData-4;

    end
    newSTC = subjSTC;
    size(allSubjData)
    

    pArray = zeros(10242,480);

    for x = 1:10242
        x
        for y = 1:480
            [~,p] = ttest(squeeze(allSubjData(x,y,:)));
            pArray(x,y) = -log(p);
        end
    end

    newSTC.data = pArray;
    outFile = strcat(dataPath,'ga/ga_',exp,'_c',int2str(condNum),'M_n',int2str(n),'_pVal-spm-',hem,'.stc');
    mne_write_stc_file(outFile,newSTC);
    
end



