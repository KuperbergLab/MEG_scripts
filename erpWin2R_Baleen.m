function erpWin2R_Baleen(subjGroup,listPrefix,t1,t2,condList)

%This script reads in both BaleenLP and BaleenHP to a single file
%This script baselines the data and gets rid of non-scalp electrodes

sample1 = round(t1/1.6666 + 61);
sample2 = round(t2/1.6666 + 61);


dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
numSubj = size(subjList,2);
numChan = 70;
chan = [316:375 379:388];

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
leftA = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/left_ant.txt');
rightA = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/right_ant.txt');
leftP = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/left_post.txt');
rightP = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/right_post.txt');
midV = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/midline_v.txt');
midH = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/midline_h.txt');
regionV = cell(numChan,1);

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


    

for x = 1:2
    if x == 1 
        exp = 'BaleenLP_All';
    elseif x==2 exp = 'BaleenHP_All';
    end
    %load allSubjData cell array
    load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix,'_',exp, '_projoff.mat'));
    

    [~,numCond] = size(condList);

    for c = 1:numCond
        cond = condList(c);
        if cond > 2
            if x == 1
                cond = cond-1;  %adjust for diff number of conditions
            end
        end
        exp
        cond


        for s = 1:numSubj
            subjStr = allSubjData{s};
            numSample = size(subjStr.evoked(1).epochs,2);

            %%For each condition, get the evoked data out
            epData = subjStr.evoked(cond).epochs(:,:);    
            baseline = mean(epData(:,baselineV),2);
            baseline = repmat(baseline,1,numSample);
            epData = epData - baseline;       
            epDataM = squeeze(mean(epData(chan,sample1:sample2),2));
            if strcmp(exp,'BaleenLP_All')
                condCode = cond;
            elseif strcmp(exp,'BaleenHP_All')
                condCode = cond+100;
            end

            size(epDataM);
            dataV = [dataV;epDataM*1e6];
            subjV = [subjV;ones(numChan,1)*subjList(s)];
            condV = [condV;ones(numChan,1)*condCode];
            chanV = [chanV;[1:numChan]'];
            hemV = [hemV;hemList];
            antV = [antV;antList];
            midVV = [midVV;midVList];
            midHV = [midHV;midHList];
        end
    end
end
allData = [subjV condV chanV dataV hemV antV midVV midHV];

outFile = strcat('/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/',listPrefix,'.BaleenAll.',int2str(t1),'-',int2str(t2),'.txt');
dlmwrite(outFile,allData,'\t')
        