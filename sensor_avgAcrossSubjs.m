function sensor_avgAcrossSubjs(exp,listPrefix)

%%Ellen Lau%%
%%This outputs two types of grand-average evoked files for viewing in
%%mne_browse_raw. The first one is a straight average, and the second one
%%'goodC' is an average that selectively excludes bad channels in
%%individuals from the average. This one is cleaner but of course it has
%%different numbers of observations going into different channels.

%%This outputs a separate set of files for EEG and MEG. For
%%comparison with standard language ERPs, it flips the polarity of the
%%signals for EEG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, exp, '.txt')))';
numSubj = size(subjList,2);

%%%%Getting the data out, loop once each for projon and projoff

for x = 1:2
    
    if x == 1
        load(strcat(dataPath, 'results/sensor_level/ave_mat/', exp, '_projoff_n',int2str(numSubj)));
        dataType = 'eeg';
        numChan = 74;
        chanV = 316:389;
    else
        load(strcat(dataPath, 'results/sensor_level/ave_mat/', exp, '_projon_n',int2str(numSubj)));
        dataType = 'meg';
        numChan = 389;
        chanV = 1:389;
    end
    

    %%Get a template fif structure from random subject average, and modify
    %%it to delete the irrelevant channels from the structure
    newStr = allSubjData{10};
    
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
    goodDataSum =zeros(numChan,numSample,numCond);
    goodDataCount = zeros(numChan,numCond);
    epCount=zeros(numCond,1);
    
    %%for each subject, get the evoked data out
    for s = 1:numSubj

        subjStr = allSubjData{s};

        %%For each condition, get the evoked data out
        for c = 1:numCond
 
            epData = subjStr.evoked(c).epochs(:,:);    
     
            %%keep a running count of how many epochs went into grand-average
            epCount(c) = epCount(c) + subjStr.evoked(c).nave;
           
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%Create the structure for the 'good channel average' separately here%%%%
            countG = 0;
            for iChan = chanV
                countG = countG +1;
                sensName = subjStr.info.ch_names{iChan};
                badTest = find(strcmp(subjStr.info.bads, sensName));
                if size(badTest,2) == 1 
                    sensName;
                end

                if size(badTest,2) == 0
                    goodDataSum(countG,:,c) = goodDataSum(countG,:,c) + epData(iChan,:);
                    goodDataCount(countG,c) = goodDataCount(countG,c)+1;
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
                             
            %%And now cut down epoch and channel name structure to the channels of interest, either EEG or MEG
            epData = epData(chanV,:);        

            %%sensor x time x condition structure for subject data
            epDataAllC(:,:,c) = epData;


        end

        %%sensor x time x condition x subject structure
        allData(:,:,:,s) = epDataAllC;
        %size(allData)
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

    outFile = strcat(dataPath,'results/sensor_level/ga_fif/ga_',exp,'_',dataType,'-n',int2str(numSubj),'-ave.fif')
    fiff_write_evoked(outFile,newStr);

    
    %%%COMPUTING THE 'GOOD CHANNEL' GRAND-AVERAGE
    
    %%Since the good channels are the same across conditions, cut redundant
    %%columns to a single 390 x 1 matrix. This structure contains info
    %%about how many observations went into each channel.
    goodDataCount = goodDataCount(:,1);
    goodDataCount'

    %%Now repeat this 390 x 1 matrix by number of samples and conditions to get
    %%equivalent dimension matrix
    goodDataCountRep = repmat(goodDataCount,[1,numSample,numCond]);

    %%Finally, array-divide them to get the correct mean for each channel
    goodDataMean = goodDataSum./goodDataCountRep;
    size(goodDataMean)

    %%plot negative up for EEG
    if strcmp(dataType,'eeg') 
        goodDataMean = -goodDataMean;
    end

    %%write epochs to 'blank' fif structure
    for y = 1:numCond
        newStr.evoked(y).epochs(:,:) = goodDataMean(:,:,y);
        newStr.evoked(y).nave = epCount(y);
    end

    outFile = strcat(dataPath,'results/sensor_level/ga_fif/ga_',exp,'_',dataType,'-n',int2str(numSubj),'-goodC-ave.fif')
    fiff_write_evoked(outFile,newStr);

end
