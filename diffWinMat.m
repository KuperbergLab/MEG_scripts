function diffWinMat(exp, dataType, subjList, cond1, cond2, t1, t2, sensType)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

count = 0;
allData=[];
condNum = 2;
subjNum = size(subjList, 2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%create initial data structure, sensors x time

for subj=subjList
    count=count+1;
    subj;
    
    %%Read in ave fif file for subject
    filename = strcat(dataPath,'ya',int2str(subj),'/ave_',dataType,'/','ya',int2str(subj),'_',exp,'-ave.fif')
    tempSubjData = fiff_read_evoked_all(filename);

    %%For each condition, get the evoked data out
    for x = 1:condNum
        temp = tempSubjData.evoked(x).epochs(:,:);
        
        %%Get rid of junk channels accidentally acquired in first subjects
        %%so matrices match up
        if (subj == 1 || subj == 3 || subj == 4 || subj == 7)
            temp(390,:) = [];
            temp(379,:) = [];
        end

        %%sensor x time x condition structure for subject data
        tempEv(:,:,x) = temp;
        
    end
    
    tempSubjData1 = tempEv(:,:,1);
    tempSubjData2 = tempEv(:,:,2);
    tempSubjDataDiff = tempSubjData2 - tempSubjData1;
    size(tempSubjDataDiff)
    allData(:,:,count) = tempSubjDataDiff;
    
    
    condData(:,:,count,1) = tempSubjData1;
    condData(:,:,count,2) = tempSubjData2;
  [m,n,o] = size(allData);
    

end


%%Baseline%%

for subj=1:subjNum
    blEp = squeeze(allData(:,1:60,subj));
    avgBlEp = mean(blEp,2);
    avgBlEpRep = repmat(avgBlEp,1,n);
    allData(:,:,subj) = allData(:,:,subj) - avgBlEpRep; 
    
end


%%%%%%%%%%%%%%%%%%
%mean across time-window

t1Samp = (t1+100) / (1000/600);
t2Samp = (t2+100) / (1000/600);
tEnd = m * (1000/600) - 101;
tAxis = linspace(-100,tEnd,m);

tData = [];

for subj = 1:subjNum
    subjMean = squeeze(mean(allData(:,t1Samp:t2Samp,subj),2));
    tData(:,subj) = subjMean;
end

if strcmp(sensType,'eeg')
    tData = tData(307:376,:);
    ch_names = tempSubjData.info.ch_names(307:376);
end

eegData = tData';
size(tData)

cond1Label = tempSubjData.evoked(cond1).comment;
cond2Label = tempSubjData.evoked(cond2).comment;
condC = strcat(cond2Label, ' - ', cond1Label)


outFile = strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/data/ga/ave_',dataType,'_',exp,condC,'-',int2str(t1),'-',int2str(t2),'n',int2str(subjNum),'.mat');


save(outFile,'eegData', 'ch_names')








