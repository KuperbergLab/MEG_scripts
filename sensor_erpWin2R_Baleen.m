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

chanGroupList = {'left_ant','right_ant','left_post','right_post'}
groupFactor = {{'left','right','left','right'},{'ant','ant','post','post'}}
chanArray = {};
dataV = []; 
regionV = cell(1,numChan);
sGroupV = cell(1,numChan);
for cg = 1:size(chanGroupList,2)
    fileName = strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/',chanGroupList{cg},'.txt');
    chanArray{cg} = dlmread(fileName);
end

for x = 1:numChan
    currChan = x;
    if x > 60 currChan = x+4;end
    for cg = 1:size(chanGroupList,2)
        if find(chanArray{cg}==currChan) regionV{x} = chanGroupList{cg};
        end
    end
    if isempty(regionV{x}) regionV{x} = 'XX';end
    sGroupV{x} = subjGroup;
end


%%assign the grouping factors to each channel
chanGroupArray = {};
groupCount = 0;
for x = 1:size(groupFactor,2)
    groupCount = groupCount+1;
    tempA = {};
    for y = 1:numChan
        if ~strcmp(regionV{y},'XX')
            pos = strmatch(regionV{y},chanGroupList,'exact');
            tempA{y} = groupFactor{x}{pos};
        else
            tempA{y} = 'XX';
        end
    end

    chanGroupArray{x} = tempA;
end


chanGroupArray{end+1} = regionV;
chanGroupArray{end+1} = sGroupV;

chanGroupArray;
allArray = chanGroupArray;
flag = 0;
for x = 1:2
    if x == 1
        exp ='BaleenLP_All';
    elseif x==2
        exp = 'BaleenHP_All';
    end 
    %load allSubjData cell array 
    load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix, '_', exp, '_',proj,'.mat'));        
    
    numCond= size(condList,2);
    totalCond = size(allSubjData{1}.evoked,2);
    
    %find condition indices
    condCodeList = zeros(numCond,1);
    for c = 1:numCond
        condLabel = condList{c};
        for y=1:totalCond
            if strcmp(condLabel,allSubjData{1}.evoked(y).comment)
                condCodeList(c) = y;
            end
        end
    end
    condCodeList;
    
    for c = 1:numCond
        condCode = condCodeList(c);
        exp;

        for s = 1:2%numSubj
            subjStr = allSubjData{s};
            numSample = size(subjStr.evoked(1).epochs,2);

            %%For each condition, get the evoked data out
            epData = subjStr.evoked(condCode).epochs(:,:);    
            baseline = mean(epData(:,baselineV),2);
            baseline = repmat(baseline,1,numSample);
            epData = epData - baseline;       
            epDataM = squeeze(mean(epData(chan,sample1:sample2),2));
            dataV = [dataV;epDataM*1e6];
            
            %%append copy to changroup array
            %%on the first run, this is correctly filled in above, so don't
            %%redo it (flag)
            if flag == 1
                for z = 1:(size(chanGroupArray,2))
                     allArray{z} = [allArray{z} chanGroupArray{z}];
                end
            else
                flag = 1;
            end
        end %%subject loop
        
    end %% condition loop
    
end %% exp loop

allData = [dataV];
%allArray{end+1} = dataV'
newArray = {};
for t = 1:size(dataV)
    for g = 1:size(allArray,2)
        newArray{t,g} =allArray{g}{t};
    end
    newArray{t,g+1} = dataV(t);
end
newArray;

    
outFile = strcat('/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/', listPrefix, '.Baleen_All.',int2str(t1),'-',int2str(t2),'.txt');
 
%dlmwrite(outFile,allData,'\t')
dlmcell(outFile,newArray,'    ');
        