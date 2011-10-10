function [allC,allC_rmsL,allC_rmsR] = sensor_rms_hem(exp,subjGroup,listPrefix,gradType)

%%Ellen Lau%%
%%This outputs all of the sensor data for each subject in each condition,
%%as well as the MEG rms in each hemisphere for each subject in the list,
%%for each condition. You choose magnetometers vs. gradiometers

%%Note that this includes a baseline step, before anything else happens

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Loading parameters%%%%%%%%%%%%%%%%%%%%%%%
dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, exp, '.txt')))';
numSubj = size(subjList,2);
baselineV = 1:60; %for 600Hz, -100 ms pre-trigger period
numChan = 306;
chanV = 1:306;

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


load(strcat(dataPath, 'results/sensor_level/ave_mat/', subjGroup, '_',exp, '_projon_n',int2str(numSubj)));


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
        baseline = mean(epData(:,baselineV),2);
        baseline = repmat(baseline,1,numSample);
        epData = epData - baseline;
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
        allC_rmsL(:,s,c) = dataL_rms;
        allC_rmsR(:,s,c) = dataR_rms;
    end
end

        
        
        
 