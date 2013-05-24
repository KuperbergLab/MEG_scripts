function sensor_erpWin2R_Baleen(subjGroup,listPrefix,t1,t2,condList,proj)

%This script reads in both BaleenLP and BaleenHP to a single
%file
%This script baselines the data and gets rid of non-scalp electrodes

sample1 = round(t1/1.6666 + 61);
sample2 = round(t2/1.6666 + 61);


dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
numSubj = size(subjList,2);
numChan = 70;
chan = [307:366 370:379]; %Not including the STI channels and RMAST 1/11/13
baselineV = 1:60;

if strcmp(subjGroup,'ya')
	groupNum = 0
elseif strcmp(subjGroup,'ac')
	groupNum = 1
elseif strcmp(subjGroup,'sc')
	groupNum = 2
end

chanGroupList = {'left_ant','right_ant'}
groupFactor = {[1 0],'hem',[1 1],'ant'}
chanArray = {}

groupV = []; dataV = []; subjV = []; condV = []; chanV = []; hemV = []; antV = []; midVV = []; midHV = []; elec9V = [];
regionV = cell(numChan,1);
region9V=cell(numChan,1);

for cg = 1:size(chanGroupList,2)
    fileName = strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/',chanGroupList{cg},'.txt')
    chanArray{cg} = dlmread(fileName)
end


%%MAKE A REGIONS VECTOR%%
leftA = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/left_ant.txt')
rightA = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/right_ant.txt');
leftP = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/left_post.txt');
rightP = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/right_post.txt');
midV = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/midline_v.txt');
midH = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/midline_h.txt');
elec9=dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/elec9.txt');

for x = 1:numChan
    currChan = x;
    if x > 60 currChan = x+4;end
    for cg = 1:size(chanGroupList,2)
        if find(chanArray{cg}==currChan) regionV{x} = chanGroupList{cg};
        end
    end
    if isempty(regionV{x}) regionV{x} = 'XX';end
end
regionV
        
for i = 1:numChan
    z=i;
    if i > 60 z=i+4;end
    if find(leftA==z) regionV{i} = 'LA';
    elseif find(rightA==z) regionV{i} = 'RA';
    elseif find(leftP==z) regionV{i} = 'LP';
    elseif find(rightP==z) regionV{i} = 'RP';
    elseif find(midV==z) regionV{i} = 'MV';
    elseif find(midH==z) regionV{i} = 'MH';
    else regionV{i} = 'XX'; i;
    end
end

for i = 1:numChan
    z=i;
    if i > 60 z=i+4;end
    if find(elec9==z) region9V{i} = 'elec9';
    else region9V{i} = 'XX'; i;
    end
end

hemList = zeros(numChan,1);
antList = zeros(numChan,1);
midVList = zeros(numChan,1);
midHList = zeros(numChan,1);
elec9List=zeros(numChan,1);

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
    
     if strcmp(region9V{i},'elec9') elec9List(i) = 1;
    end
end


for x = 1:2
    if x == 1
        exp ='BaleenLP_All'
    elseif x==2
        exp = 'BaleenHP_All';
    end 
    %load allSubjData cell array 
    load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix, '_', exp, '_',proj,'.mat'));        
    
    [blah,numCond] = size(condList);
    totalCond = size(allSubjData{1}.evoked,2)
    
    %find condition indices
    condCodeList = zeros(numCond,1);
    for c = 1:numCond
        condLabel = condList{c};
        for x=1:totalCond
            if strcmp(condLabel,allSubjData{1}.evoked(x).comment)
                condCodeList(c) = x;
            end
        end
    end
    condCodeList
    
    for c = 1:numCond
        condCode = condCodeList(c);
        exp

        for s = 1:numSubj
            subjStr = allSubjData{s};
            numSample = size(subjStr.evoked(1).epochs,2);

            %%For each condition, get the evoked data out
            epData = subjStr.evoked(condCode).epochs(:,:);    
            baseline = mean(epData(:,baselineV),2);
            baseline = repmat(baseline,1,numSample);
            epData = epData - baseline;       
            epDataM = squeeze(mean(epData(chan,sample1:sample2),2));
  
            size(epDataM);
            dataV = [dataV;epDataM*1e6];
            groupV = [groupV;ones(numChan,1)*groupNum];
            subjV = [subjV;ones(numChan,1)*subjList(s)];
            chanV = [chanV;[1:numChan]'];
            hemV = [hemV;hemList];
            antV = [antV;antList];
            midVV = [midVV;midVList];
            midHV = [midHV;midHList];
            elec9V=[elec9V; elec9List];
        end
    end
end
allData = [groupV subjV chanV dataV hemV antV midVV midHV elec9V];


outFile = strcat('/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/', listPrefix, '.Baleen_All.',int2str(t1),'-',int2str(t2),'.txt');
 
dlmwrite(outFile,allData,'\t')
        