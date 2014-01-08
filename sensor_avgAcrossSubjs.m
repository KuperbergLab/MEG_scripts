%%Example: sensor_avgAcrossSubjs('MaskedMM_All','ac', 'ac.n12.meeg.mm')
%%Usagev: sensor_avgAcrossSubjs('ExpName','subjgrp', 'listPrefix')

function sensor_avgAcrossSubjs(exp,subjGroup,listPrefix)

%%Ellen Lau%%
%%This outputs grand-average evoked files for viewing in
%%mne_browse_raw. 

%%This outputs a separate set of files for EEG and MEG. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';

%%Information for template subject
tempSubj = 33  %%enter actual subj num here (if sc19, enter 19);  
tempSubjListPrefix = 'ac.meg.all' %%enter a list that this subject appears in .mat file;
tempSubjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',tempSubjListPrefix, '.txt')))'

if subjGroup == 'ya'
    tempSubj = 6
    tempSubjListPrefix = 'ya.n18.ax' %% for YA AXCPT 
    tempSubjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',tempSubjListPrefix, '.txt')))'
end
    
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))'
numSubj = size(subjList,2)

%%Get a template fif structure from random subject average, and modify
%%it to delete the irrelevant channels from the structure
load(strcat(dataPath, 'results/sensor_level/ave_mat/', tempSubjListPrefix, '_', exp, '_projon.mat'));
    tempSubjIndex = find(tempSubjList == tempSubj)
    newStr = allSubjData{tempSubjIndex};

%%%%Getting the data out
for x = 2:2 %%legacy loop for projon
    
    if x == 1 %outdated not using now... 
        load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix,'_', exp, '_projon.mat'));
        dataType = 'eeg';
        numChan = 74;
        chanV = 307:380;
            
    elseif x == 2
       
        %%Get the actual data
        load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix, '_', exp, '_projon.mat'));
        dataType = 'meg';
        if ~strcmp(subjGroup,'ya')
             numChan = 380;
             chanV = 1:380; %previously 389 %%ac sc 380
        else 
             numChan = 389;
             chanV = 1:389; %previously 389 %%ac sc 380
        end
    end
end

%  
    numSample = size(newStr.evoked(1).epochs,2);
    numCond = size(newStr.evoked,2);
    if strcmp(exp, 'ATLLoc') 
        numCond = 3; 
        newStr.evoked = newStr.evoked(1:3);
    end     %%don't want to try to average the whole-sentence epochs

    newStr.info.chs = newStr.info.chs(chanV);
    for z = 1:numChan
        tempName{z} = newStr.info.ch_names(chanV(z));
    end
    newStr.info.ch_names = tempName;
    newStr.info.bads = {};
    newStr.info.nchan = numChan;

    for c = 1:numCond
        newStr.evoked(c).epochs = newStr.evoked(c).epochs(chanV,:);
    end
    
    %%Initialize variables
    allData=zeros(numChan,numSample,numCond,numSubj);
    epCount=zeros(numCond,1);
    numCond = size(newStr.evoked,2);
    
    
    %%for each subject, get the evoked data out
    for s = 1:numSubj
        subjStr = allSubjData{s}
        s

        %%For each condition, get the evoked data out
        for c = 1:numCond
 
            epData = subjStr.evoked(c).epochs(:,:);    
     
            %%keep a running count of how many epochs went into grand-average
            epCount(c) = epCount(c) + subjStr.evoked(c).nave;

            %%And now cut down epoch and channel name structure to the channels of interest, either EEG or MEG
            epData = epData(chanV,:);        

            %%sensor x time x condition structure for subject data
            epDataAllC(:,:,c) = epData;
        end
 
        %%update sensor x time x condition x subject structure
        allData(:,:,:,s) = epDataAllC;
epDataAllC(1,1,2)
        clear('epData');
        clear('epDataAllC');
    end
    
    %%%COMPUTING REGULAR GRAND-AVERAGE%%%%

    gaData = mean(allData,4);

    %%write epochs to 'blank' fif structure
    for y = 1:numCond
        newStr.evoked(y).epochs(:,:) = gaData(:,:,y);
        newStr.evoked(y).nave = epCount(y);
    end
    %newStr.evoked(1).epochs
    outFile = strcat(dataPath,'results/sensor_level/ga_fif/ga_',listPrefix, '_',exp,'_projon-ave.fif')
    fiff_write_evoked(outFile,newStr);
    
end