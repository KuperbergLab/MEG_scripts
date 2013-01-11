function sensor_erpWinDiff2R_Baleen(subjGroup,listPrefix,t1,t2)

%This script reads in both BaleenLP and BaleenHP to a single file
%This script baselines the data and gets rid of non-scalp electrodes
%Subtracts Unrel-Rel in each block

sample1 = round(t1/1.6666 + 61);
sample2 = round(t2/1.6666 + 61);


dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
numSubj = size(subjList,2);
numChan = 70;
chan = [307:366 370:379]; %Not including the STI channels and RMAST 1/11/13
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


%      

for x = 1:2
    if x == 1
        exp ='BaleenLP_All'
    elseif x==2
        exp = 'BaleenHP_All';
    end 
    %load allSubjData cell array 
    load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix, '_', exp, '_projoff.mat'));        
    
    cond1 = 1
    cond2 = 2

    for s = 1:numSubj
        subjStr = allSubjData{s};
        numSample = size(subjStr.evoked(1).epochs,2);

        %%For each condition, get the evoked data out
        epData1 = subjStr.evoked(cond1).epochs(:,:);    
        baseline1 = mean(epData1(:,baselineV),2);
        baseline1 = repmat(baseline1,1,numSample);
        epData1 = epData1 - baseline1;       
        epDataM1 = squeeze(mean(epData1(chan,sample1:sample2),2));

         %%For each condition, get the evoked data out
        epData2 = subjStr.evoked(cond2).epochs(:,:);    
        baseline2 = mean(epData2(:,baselineV),2);
        baseline2 = repmat(baseline2,1,numSample);
        epData2 = epData2 - baseline2;       
        epDataM2 = squeeze(mean(epData2(chan,sample1:sample2),2));

        epDataM = epDataM2-epDataM1;

        if strcmp(exp,'BaleenLP_All')
            condCode = 201;
        elseif strcmp(exp,'BaleenHP_All')
            condCode = 202;
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
allData = [subjV condV chanV dataV hemV antV midVV midHV];


outFile = strcat('/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/', listPrefix, '.BaleenAll.Diff.',int2str(t1),'-',int2str(t2),'.txt');
 
dlmwrite(outFile,allData,'\t')
        