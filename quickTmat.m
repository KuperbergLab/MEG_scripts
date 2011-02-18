function p = quickT(exp, dataType, subjList, cond1, cond2, t1, t2, sensName)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

count = 0;
allData=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%create initial data structure, sensors x time

for subj=subjList

    count = count + 1;
    inFile = strcat(dataPath,'ya',int2str(subj),'/ave_',dataType,'/','ya',int2str(subj),'_',exp,'-ave.fif')
    tempSubjData = fiff_read_evoked_all(inFile);
    
    nchan = tempSubjData.info.nchan;
    
    for ichan = 1:nchan
        if strcmp(tempSubjData.info.ch_names{ichan}, sensName)
            chanNum = ichan;
        end
    end
        
    
    tempSubjDataSens1 = squeeze(tempSubjData.evoked(cond1).epochs(chanNum,:));
    tempSubjDataSens2 = squeeze(tempSubjData.evoked(cond2).epochs(chanNum,:));
    tempSubjDataSensDiff = tempSubjDataSens2 - tempSubjDataSens1;
    
    allData(:,count) = tempSubjDataSensDiff;
    
    condData(:,count,1) = tempSubjDataSens1;
    condData(:,count,2) = tempSubjDataSens2;
    
end

cond1Label = tempSubjData.evoked(cond1).comment;
cond2Label = tempSubjData.evoked(cond2).comment;
strcat(cond2Label, ' - ', cond1Label)
[m,n] = size(allData);

%%%%%%%%%%%%%%%%%
%baseline data

for subj=1:n
    blEp = allData(1:60,subj);
    avgBlEp = mean(blEp);
    avgBlEpRep = repmat(avgBlEp,1,m);
    size(avgBlEpRep);
    allData(:,subj) = allData(:,subj) - avgBlEpRep'; 
    
    blEp1 = condData(1:60,subj,1);
    avgBlEp1 = mean(blEp1);
    avgBlEpRep1 = repmat(avgBlEp1,1,m);
    size(avgBlEpRep1);
    condData(:,subj,1) = condData(:,subj,1) - avgBlEpRep1'; 
    
    blEp2 = condData(1:60,subj,2);
    avgBlEp2 = mean(blEp2);
    avgBlEpRep2 = repmat(avgBlEp2,1,m);
    size(avgBlEpRep2);
    condData(:,subj,2) = condData(:,subj,2) - avgBlEpRep2'; 

end

%%%%%%%%%%%%%%%%%%
%run t-test

t1Samp = (t1+100) / (1000/600);
t2Samp = (t2+100) / (1000/600);
tEnd = m * (1000/600) - 101;
tAxis = linspace(-100,tEnd,m);

tData = [];

for subj = 1:n
    subjMean = mean(allData(t1Samp:t2Samp,subj),1);
    tData(subj) = subjMean;
end

mean(tData);
std(tData);

[h,p,ci,stats] = ttest(tData)

%figure;plot(tAxis,mean(allData,2));title(strcat(sensName,'-',int2str(cond2), '-',int2str(cond1), ' ',int2str(t1),'-',int2str(t2)))
%figure;plot(tAxis,mean(condData(:,:,1),2));hold;plot(tAxis,mean(condData(:,:,2),2),'r');title(strcat(sensName,'-',int2str(cond2), '-',int2str(cond1), ' ',int2str(t1),'-',int2str(t2)))

end


