function [p,contrast] = quickT(exp, dataType, cond1, cond2, t1, t2, sensName, format)

%%This function computes t-test at an individual sensor, for a given
%%time-window. Designed for comparing two conditions, but enter the 
%%same condition number twice if you want to do a one-way test on
%%one condition

%%By default most of the work here is done on the diff vector. The cond
%%structures are mostly just there in case you want to plot the sensor
%%waveform for each condition separately, in the commented lines at the end

if (strcmp(exp,'BaleenHP_All') || strcmp(exp,'BaleenLP_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.baleen.meg-mri.txt');
elseif (strcmp(exp,'MaskedMM_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.masked.meg-mri.txt');
end

subjList = subjList';


dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

count = 0;
goodCount = 0;
allData=[];

if cond1==cond2
   msg = 'Running one condition t-test'
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%create initial data structure, sensors x time

[m,nSubj] = size(subjList);

%%Case: Load data from mat file
if format == 'mat'
   inFile = strcat(dataPath, 'ga/mat/ave_', dataType, '_',exp, '_n=',int2str(nSubj), '.mat');
   load(inFile)
end

for subj=subjList
    count = count + 1;

    %%Case: Read fif files directly
    if format == 'fif'    
        inFile = strcat(dataPath,'ya',int2str(subj),'/ave_',dataType,'/','ya',int2str(subj),'_',exp,'-ave.fif')
        tempSubjData = fiff_read_evoked_all(inFile);    
    end
    
    %%Case: Load data from mat file
    if format == 'mat'
        tempSubjData = allSubjData{count};
    end
    
    %%Only do the rest (add subject data to array) if not marked as bad
    %%channel
    
    badTest = find(strcmp(tempSubjData.info.bads, sensName));
    if size(badTest,2) == 1 
        g = 99
        subj
    end
    
    %%Now add all this stuff to the data array for this channel
    if size(badTest,2) == 0
        goodCount = goodCount + 1;
        nchan = tempSubjData.info.nchan;
    
        %%Find out for this subject, which number corresponds to this channel
        %%name
        chanNum = [];
        for ichan = 1:nchan
            if strcmp(tempSubjData.info.ch_names{ichan}, sensName)
                chanNum = ichan;
            end
        end
        
        %%If you don't find a match, print an error message
        
        if (isempty(chanNum)) 
            error('Error, incorrect channel name')  
        end
        
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
        condData(:,goodCount,1) = tempSubjDataSens1;
        condData(:,goodCount,2) = tempSubjDataSens2;
    
    end
    
end
goodCount;

cond1Label = tempSubjData.evoked(cond1).comment;
cond2Label = tempSubjData.evoked(cond2).comment;
contrast = strcat(cond2Label, '-', cond1Label);

%%get the size of the new structure
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
tData;

[h,p,ci,stats] = ttest(tData);

%figure;plot(tAxis,mean(allData,2));title(strcat(sensName,'-',int2str(cond2), '-',int2str(cond1), ' ',int2str(t1),'-',int2str(t2)))
%figure;plot(tAxis,mean(condData(:,:,1),2));hold;plot(tAxis,mean(condData(:,:,2),2),'r');title(strcat(sensName,'-',int2str(cond2), '-',int2str(cond1), ' ',int2str(t1),'-',int2str(t2)))

end


