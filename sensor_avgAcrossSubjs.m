%%Example: sensor_avgAcrossSubjs('MaskedMM_All', 'ac.n12.meeg.mm')
%%Usagev: sensor_avgAcrossSubjs('ExpName', 'listPrefix')

function sensor_avgAcrossSubjs(exp,listPrefix)

%%Ellen Lau%%
%%This outputs grand-average evoked files for viewing in
%%mne_browse_raw. 

%%This outputs a separate set of files for EEG and MEG. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
%tempSubj= (dlmread(strcat(dataPath,'scripts/function_inputs/ac.meg.31.txt')))';
tempSubj=(dlmread(strcat(dataPath,'scripts/function_inputs/sc.meg.19.txt')))'; %%Using sc.meg.19 when testing for avgRef projections on grand average. 

numSubj = size(subjList,2);

numSubj

%%%%Getting the data out, loop once each for projon and projoff

for x = 1:2
    
    if x == 1
        load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix,'_', exp, '_projoff.mat'));
        dataType = 'eeg';
        numChan = 74;
        chanV = 307:380;
        
    elseif x == 2
        load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix, '_', exp, '_projoff.mat'));
        dataType = 'meg';
        numChan = 380;
        chanV = 1:380; %previously 389
    
    %%Get a template fif structure from random subject average, and modify
    %%it to delete the irrelevant channels from the structure
    for subj=tempSubj
       %%load(strcat(dataPath, 'results/sensor_level/ave_mat/ac.meg.31_',exp, '_projoff.mat')); %%Using the template ac31  to accomodate for the change in ac, sc data structure - EEG channels(307-380) in new subjects and (316-389) in old subjects(STI(307-315) deleted)
       load(strcat(dataPath, 'results/sensor_level/ave_mat/sc.meg.19_',exp, '_projoff.mat')); %%For  Avgref test: Using the template sc19  to accomodate for the change in ac, sc data structure - EEG channels(307-380) in new subjects and (316-389) in old subjects(STI(307-315) deleted)
       %load(strcat(dataPath, 'results/sensor_level/ave_mat/ac.meg.31_',exp, '_projoff.mat'));
       newStr = TempSubjData{1};    
   
end
 %%Get a template fif structure from random subject average, and modify
    %%it to delete the irrelevant channels from the structure
   % newStr = allSubjData{5};
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
        subjStr = allSubjData{s};
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

    outFile = strcat(dataPath,'results/sensor_level/ga_fif/ga_',listPrefix, '_',exp,'_',dataType,'-ave.fif')
    fiff_write_evoked(outFile,newStr);
    
end
