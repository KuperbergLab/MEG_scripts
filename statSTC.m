function pArray = statSTC(subjList)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

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

for x = 1:10242
    x
    for y = 1:480
        [~,p] = ttest(squeeze(allSubjData(x,y,:)));
        pArray(x,y) = -log(p);
    end
end

newSTC.data = pArray;
outFile = strcat(dataPath,'ga/ga_diffSTC_pVal_n',int2str(n),'-spm-lh.stc');
mne_write_stc_file(outFile, newSTC);



