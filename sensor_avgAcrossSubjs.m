function sensor_avgAcrossSubjs(exp,subjGroup,listPrefix)

%%Ellen Lau%%
%%This outputs grand-average evoked files for viewing in
%%mne_browse_raw. 

%%This outputs a separate set of files for EEG and MEG. For
%%comparison with standard language ERPs, it flips the polarity of the
%%signals for EEG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
numSubj = size(subjList,2);

%%%%Getting the data out, loop once each for projon and projoff

for x = 1:2
    
    if x == 1
        load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix,'_',exp, '_projoff.mat'));
        dataType = 'eeg';
        numChan = 74;
        chanV = 316:389;
    else
        load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix, '_',exp, '_projon.mat'));
        dataType = 'meg';
        numChan = 389;
        chanV = 1:389;
    end
    

    %%Get a template fif structure from random subject average, and modify
    %%it to delete the irrelevant channels from the structure
    newStr = allSubjData{5};
    
    numSample = size(newStr.evoked(1).epochs,2);
    numCond = size(newStr.evoked,2);
    if strcmp(exp, 'ATLLoc') 
        numCond = 3; 
        newStr.evoked(4:6) = [];
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
    
    allData=zeros(numChan,numSample,numCond,numSubj);
    epCount=zeros(numCond,1);
    
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

    %%plot negative up for EEG
    if strcmp(dataType,'eeg') 
        gaData = -gaData;
    end

    %%write epochs to 'blank' fif structure
    for y = 1:numCond
        newStr.evoked(y).epochs(:,:) = gaData(:,:,y);
        newStr.evoked(y).nave = epCount(y);
    end

    outFile = strcat(dataPath,'results/sensor_level/ga_fif/ga_',listPrefix, '_',exp,'_',dataType,'-ave.fif')
    fiff_write_evoked(outFile,newStr);

       
    
end
