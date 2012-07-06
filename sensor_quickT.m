function [p,contrast] = sensor_quickT(exp, subjGroup, listPrefix,projType, cond1, cond2, t1, t2, chanNum)

%%This function computes t-test at an individual sensor, for a given
%%time-window. Designed for comparing two conditions, but enter the 
%%same condition number twice if you want to do a one-way test on
%%one condition

%%By default most of the work here is done on the diff vector. The cond
%%structures are mostly just there in case you want to plot the sensor
%%waveform for each condition separately, in the commented lines at the end

load('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/MEG_Chan_Names/ch_names.mat')
dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
numSubj = size(subjList,2);

if strcmp(projType,'projon') 
    dataType = 'meg';
elseif strcmp(projType,'projoff')
    dataType = 'eeg';
end


count = 0;
goodCount = 0;
allData=[];
sensName = ch_names{chanNum}

if cond1==cond2
   msg = 'Running one condition t-test'
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%create initial data structure, sensors x time



load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix, '_',exp,'_',projType, '.mat'));

for subj=subjList
    count = count + 1;
    
    tempSubjData = allSubjData{count};
    
    %%Only do the rest (add subject data to array) if not marked as bad
    %%channel
    badTest = [];
    if strcmp(dataType,'meg')
        badTest = find(strcmp(tempSubjData.info.bads, sensName));

        if size(badTest,2) == 1 
            msg = 'bad channel'
            sensName
            subj
        end        
    end

    %%Now add all this stuff to the time x subj data array
    if size(badTest,2) == 0
        goodCount = goodCount + 1;
        nchan = tempSubjData.info.nchan;
            
        %%Extract the epochs
        tempSubjDataSens1 = squeeze(tempSubjData.evoked(cond1).epochs(chanNum,:));
        tempSubjDataSens2 = squeeze(tempSubjData.evoked(cond2).epochs(chanNum,:));
        tempSubjDataSensDiff = tempSubjDataSens2 - tempSubjDataSens1;
        
        %%Add the diff vector to allData, time x subj structure
        if (cond1 ~= cond2)
            allData(:,goodCount) = tempSubjDataSensDiff;
        end
        
        %%If just want to test one condition, add a condition vector instead
        if (cond1 == cond2)
            allData(:,goodCount) = tempSubjDataSens1;
        end
    
        %%Make structures for individual conditions for plotting
%         condData(:,goodCount,1) = tempSubjDataSens1;
%         condData(:,goodCount,2) = tempSubjDataSens2;
    
    end
    
end

% goodCount;
% 
cond1Label = tempSubjData.evoked(cond1).comment;
cond2Label = tempSubjData.evoked(cond2).comment;
contrast = strcat(cond2Label, '-', cond1Label);

%%get the size of the new structure
[m,n] = size(allData);


%%set up t variables
t1Samp = (t1+100) / (1000/600);
t2Samp = (t2+100) / (1000/600);
tEnd = m * (1000/600) - 101;
tAxis = linspace(-100,tEnd,m);

tData = [];

%%%%%%%%%%%%%%%%%
%baseline data

for subj=1:n
%    blEp = allData(1:60,subj);
     avgBlEpRep = repmat(mean(allData(1:60,subj)),1,m);
     allData(:,subj) = allData(:,subj) - avgBlEpRep'; 
    
%     blEp1 = condData(1:60,subj,1);
%     avgBlEp1 = mean(blEp1);
%     avgBlEpRep1 = repmat(avgBlEp1,1,m);
%     size(avgBlEpRep1);
%     condData(:,subj,1) = condData(:,subj,1) - avgBlEpRep1'; 
%     
%     blEp2 = condData(1:60,subj,2);
%     avgBlEp2 = mean(blEp2);
%     avgBlEpRep2 = repmat(avgBlEp2,1,m);
%     size(avgBlEpRep2);
%     condData(:,subj,2) = condData(:,subj,2) - avgBlEpRep2'; 
    subjMean = mean(allData(t1Samp:t2Samp,subj),1);
    tData(subj) = subjMean;
end

%%%%%%%%%%%%%%%%%%
%run t-test


% tData;
% mean(tData);
% std(tData);
%bar(tData);

[h,p,ci,stats] = ttest(tData);


%figure;plot(tAxis,mean(allData,2));title(strcat(sensName,'-',int2str(cond2), '-',int2str(cond1), ' ',int2str(t1),'-',int2str(t2)))
%figure;plot(tAxis,mean(condData(:,:,1),2));hold;plot(tAxis,mean(condData(:,:,2),2),'r');title(strcat(sensName,'-',int2str(cond2), '-',int2str(cond1), ' ',int2str(t1),'-',int2str(t2)))

end


