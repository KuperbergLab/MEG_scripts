function [allC,allC_rmsL,allC_rmsR] = sensor_rms_hem(exp,subjGroup,listPrefix,gradType)

%%Ellen Lau%%
%%This outputs all of the sensor data for each subject in each condition,
%%as well as the MEG rms in each hemisphere for each subject in the list,
%%for each condition. You choose magnetometers vs. gradiometers

%%Note that this includes a baseline step, before anything else happens,
%%except for ATLLoc, since that one is high-pass filtered

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Loading parameters%%%%%%%%%%%%%%%%%%%%%%%
dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
numSubj = size(subjList,2);
baselineV = 1:60; %for 600Hz, -100 ms pre-trigger period
numChan = 389;
chanV = 1:389;

load(strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/l',gradType,'.mat'))
load(strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/r',gradType,'.mat'))
if strcmp(gradType, 'grad')
    lchan = lgrad;
    rchan = rgrad;
end
if strcmp(gradType, 'mag')
    lchan = lmag;
    rchan = rmag;
end
if strcmp(gradType, 'eeg')
    lchan = leeg;
    rchan = reeg;
end


load(strcat(dataPath, 'results/sensor_level/ave_mat/', subjGroup, '_',exp, '_projon_n',int2str(numSubj)));
if strcmp(gradType, 'eeg')
    load(strcat(dataPath, 'results/sensor_level/ave_mat/', subjGroup, '_',exp, '_projoff_n',int2str(numSubj)));
end


%%Get a test fif structure from random subject average to figure out
%%parameters
testStr = allSubjData{1};
numSample = size(testStr.evoked(1).epochs,2);
numCond = size(testStr.evoked,2);
%%don't want to try to average the whole-sentence epochs
if strcmp(exp, 'ATLLoc') 
    numCond = 3; 
end     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%Reading in data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

allC = zeros(numChan,numSample,numSubj,numCond);

for c = 1:numCond
    
    for s = 1:numSubj
        subjStr = allSubjData{s};
        %%For each condition, get the evoked data out
        epData = subjStr.evoked(c).epochs(chanV,:);
        %%Baseline it
        if ~strcmp(exp,'ATLLoc')
            baseline = mean(epData(:,baselineV),2);
            baseline = repmat(baseline,1,numSample);
            epData = epData - baseline;
        end
        %%Add it to array
        allC(:,:,s,c) = epData;
    end
   
end


%%%%Compute RMS by hemisphere%%%%%%%%%%%%%%%%

allC_rmsL = zeros(numSample,numSubj,numCond);
allC_rmsR = zeros(numSample,numSubj,numCond);

for c = 1:numCond
    for s = 1:numSubj
         %%get rid of bad channels
        subjStr = allSubjData{s};
        badIndex = [];
        for i = 1:size(subjStr.info.bads,2)
            badIndex(end+1) = find(strcmp(subjStr.info.bads{i},subjStr.info.ch_names));
        end
        lchanG = setdiff(lchan,badIndex);
        rchanG = setdiff(rchan,badIndex);
        data = squeeze(allC(:,:,s,c));
        dataL = data(lchanG,:);
        dataR = data(rchanG,:);
        dataL_rms = squeeze(sqrt(mean((dataL.^2),1)));
        dataR_rms = squeeze(sqrt(mean((dataR.^2),1)));
        if strcmp(gradType, 'eeg')
            dataL_rms = squeeze(mean(dataL,1));
            dataR_rms = squeeze(mean(dataR,1));
        end
        allC_rmsL(:,s,c) = dataL_rms;
        allC_rmsR(:,s,c) = dataR_rms;
    end
end

time = -100:1.666:700;
%figure;plot(time,(mean(allC_rmsL(:,:,2),2)-mean(allC_rmsL(:,:,1),2)),'k');hold;plot(time,(mean(allC_rmsR(:,:,2),2)-mean(allC_rmsR(:,:,1),2)),'r')        
%%%%%figure;plot(time,mean(allC_rmsR(:,:,1),2),'k');hold;plot(time,mean(allC_rmsR(:,:,2),2),'r')        
        
        
 