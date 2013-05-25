function sensor_erpWin2R_Baleen(subjGroup,listPrefix,t1,t2,condList,proj,chanGroupFileName)

%This script assumes a channel grouping file has been created with
%setupEEGChanGroups.m
%This script reads in both BaleenLP and BaleenHP to a single file
%This script baselines the data with a hard-coded 60 sample baseline window

sample1 = round(t1/1.6666 + 61);
sample2 = round(t2/1.6666 + 61);

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
numSubj = size(subjList,2);
baselineV = 1:60;
numChan = 70;
chan = [307:366 370:379]; %Not including the STI channels and RMAST 1/11/13

dataV = []; 

%load chanGroupArray
load(strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/',chanGroupFileName,'.mat'))

%add subjGroup info
sGroupV = cell(1,numChan);
for x = 1:numChan
    sGroupV{x} = subjGroup;
end
chanGroupArray{end+1} = sGroupV;

%Now make the big data array
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

    
outFile = strcat('/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/', listPrefix, '.Baleen_All.',chanGroupFileName,'.',int2str(t1),'-',int2str(t2),'.txt');
 
%dlmwrite(outFile,allData,'\t')
dlmcell(outFile,newArray,'    ');
        