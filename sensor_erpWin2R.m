function sensor_erpWin2R(exp,subjGroup,listPrefix,t1,t2,condList)

%ex" erpWin2R('ATLLoc', 'ac','ac.meg.ATLLoc',300, 500, [1 3 4])
%This script baselines the data


sample1 = round(t1/1.6666 + 61);
sample2 = round(t2/1.6666 + 61);


dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
numSubj = size(subjList,2);
numChan = 74;
chan = 316:389;
baselineV = 1:60;

dataV = [];
subjV = [];
condV = [];
chanV = [];
hemV = [];
antV = [];
midVV = [];
midHV = [];

%%MAKE A REGIONS VECTOR%%
leftA = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/left_ant.txt');
rightA = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/right_ant.txt');
leftP = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/left_post.txt');
rightP = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/right_post.txt');
midV = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/midline_v.txt');
midH = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/midline_h.txt');
regionV = cell(numChan,1);

for i = 1:numChan
    z=i;
    if i > 60 z=i+4;end
    if find(leftA==z) regionV{i} = 'LA';
    elseif find(rightA==z) regionV{i} = 'RA';
    elseif find(leftP==z) regionV{i} = 'LP';
    elseif find(rightP==z) regionV{i} = 'RP';
    elseif find(midV==z) regionV{i} = 'MV'; %vertical midline
    elseif find(midH==z) regionV{i} = 'MH'; %horizontal midline
    else regionV{i} = 'XX'; i;
    end
end

hemList = zeros(numChan,1);
antList = zeros(numChan,1);
midVList = zeros(numChan,1);
midHList = zeros(numChan,1);

for i = 1:numChan
    if (strcmp(regionV{i},'LA')) | (strcmp(regionV{i},'LP')) hemList(i) = 1;
    elseif (strcmp(regionV{i},'RA')) | (strcmp(regionV{i},'RP')) hemList(i) = 2;
    end
    
    if (strcmp(regionV{i},'LA')) | (strcmp(regionV{i},'RA')) antList(i) = 1;
    elseif (strcmp(regionV{i},'LP')) | (strcmp(regionV{i},'RP')) antList(i) = 2;
    end
    
    if strcmp(regionV{i},'MV') midVList(i) = 1;
    end
    
    if strcmp(regionV{i},'MH') midHList(i) = 1;
    end
end

load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix,'_',exp, '_projoff.mat'));
[blah,numCond] = size(condList);
numCond

for c = 1:numCond
    c  
    for s = 1:numSubj
        subjStr = allSubjData{s};
        numSample = size(subjStr.evoked(1).epochs,2);

        %%For each condition, get the evoked data out
        s
        subjStr.evoked
        epData = subjStr.evoked(condList(c)).epochs(:,:);
       
        baseline = mean(epData(:,baselineV),2);
        baseline = repmat(baseline,1,numSample);
        epData = epData - baseline;       
        epDataM = squeeze(mean(epData(chan,sample1:sample2),2));
 
        size(epDataM);
        dataV = [dataV;epDataM*1e6];
        subjV = [subjV;ones(numChan,1)*subjList(s)];
        condV = [condV;ones(numChan,1)*condList(c)];
        chanV = [chanV;[1:numChan]'];
        hemV = [hemV;hemList];
        antV = [antV;antList];
        midVV = [midVV;midVList];
        midHV = [midHV;midHList];
        
    end
end
allData = [subjV condV chanV dataV hemV antV midVV midHV];

outFile = strcat('/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/',listPrefix,'.',exp,'.',int2str(t1),'-',int2str(t2),'.txt');
dlmwrite(outFile,allData,'\t')
        