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


%%%%Getting the data out, loop once each for projon and projoff

for x = 1:2
    
    if x == 1
        load(strcat(dataPath, 'results/sensor_level/ave_mat/', exp, '_projoff_n',int2str(count)));
    else
        projType = 'projon';
        dataType = 'meg';
        chanNum = 306;
        chanV = [1:306];
    end
    
    %%Select subject list, depending on whether doing EEG or MEG
    if (strcmp(exp,'BaleenHP_All') || strcmp(exp,'BaleenLP_All'))
        subjList = dlmread(strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/ya.baleen.',dataType,'.txt'));
    elseif (strcmp(exp,'MaskedMM_All'))
        subjList = dlmread(strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/ya.masked.',dataType,'.txt'));
    end
    subjList = subjList'


    %%Get a template fif structure from random subject average, and modify
    %%it to delete the irrelevant channels from the structure
    newStr = fiff_read_evoked_all(strcat(dataPath,'ya17/ave_',projType,'/ya17_',exp,'-ave.fif'));
    newStr.info.chs = newStr.info.chs([chanV]);
    newStr.info.bads = {};
    
    for z = 1:chanNum
        tempName{z} = newStr.info.ch_names(chanV(z));
    end
    newStr.info.ch_names = tempName;
        
    newStr.info.nchan = chanNum;
    for y = 1:size(newStr.evoked,2)
        newStr.evoked(y).epochs = newStr.evoked(y).epochs(chanV,:);
    end
    
   
    %%Initialize variables
    sampleNum = size(newStr.evoked(1).epochs,2)
    condNum = size(newStr.evoked,2);
    %chanNum = 390;
    count = 0;
    allData=[];
    goodDataSum =zeros(chanNum,sampleNum,condNum);
    goodDataCount = zeros(chanNum,condNum);
    epCount=zeros(condNum,1);
    
    %%don't want to try to average the whole-sentence epochs
    if strcmp(exp, 'ATLLoc') condNum = 3; end  


    %%for each subject, get the evoked data out
    for subj=subjList
        count=count+1
        subj

        %%Read in ave fif file for subject
        filename = strcat(dataPath,'ya',int2str(subj),'/ave_',projType,'/','ya',int2str(subj),'_',exp,'-ave.fif')
        tempStr = fiff_read_evoked_all(filename);

        %%For each condition, get the evoked data out
        for c = 1:condNum
 
            temp = tempStr.evoked(c).epochs(:,:);    
     
            %%keep a running count of how many epochs went into grand-average
            epCount(c) = epCount(c) + tempStr.evoked(c).nave;
           
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%First create the structure for the 'good channel average' separately here%%%%
            countG = 0;
            for iChan = chanV
                countG = countG +1;
                sensName = tempStr.info.ch_names{iChan};
                badTest = find(strcmp(tempStr.info.bads, sensName));
                if size(badTest,2) == 1 
                    sensName;
                end

                if size(badTest,2) == 0
                    goodDataSum(countG,:,c) = goodDataSum(countG,:,c) + temp(iChan,:);
                    goodDataCount(countG,c) = goodDataCount(countG,c)+1;
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            

           %%First get rid of junk channels accidentally acquired in first subjects
            %%so matrices match up
            if (subj == 1 || subj == 3 || subj == 4 || subj == 7)
                temp(390,:) = [];
                temp(379,:) = [];
            end
                             
            %%And now cut down epoch and channel name structure to the channels of interest, either EEG or MEG
            temp = temp(chanV,:);
            %tempStr.info.chs = tempStr.info.chs([chanV]);
        

            %%sensor x time x condition structure for subject data
            tempEv(:,:,c) = temp;


        end

        %%sensor x time x condition x subject structure
        allData(:,:,:,count) = tempEv;
        size(allData)
        clear('tempEv');
        clear('tempStr');


    end
    
    %%%COMPUTING REGULAR GRAND-AVERAGE%%%%

    gaData = mean(allData,4);

    %%plot negative up for EEG
    if strcmp(dataType,'eeg') 
        gaData = -gaData;
    end

    %%write epochs to 'blank' fif structure
    for y = 1:condNum
        newStr.evoked(y).epochs(:,:) = gaData(:,:,y);
        newStr.evoked(y).nave = epCount(y);
    end

    outFile = strcat(dataPath,'ga/ga_ave_',exp,'_',dataType,'-n',int2str(count),'-ave.fif')
    fiff_write_evoked(outFile,newStr);

    
    %%%COMPUTING THE 'GOOD CHANNEL' GRAND-AVERAGE
    
    %%Since the good channels are the same across conditions, cut redundant
    %%columns to a single 390 x 1 matrix. This structure contains info
    %%about how many observations went into each channel.
    goodDataCount = goodDataCount(:,1);
    goodDataCount'

    %%Now repeat this 390 x 1 matrix by number of samples and conditions to get
    %%equivalent dimension matrix
    goodDataCountRep = repmat(goodDataCount,[1,sampleNum,condNum]);

    %%Finally, array-divide them to get the correct mean for each channel
    goodDataMean = goodDataSum./goodDataCountRep;
    size(goodDataMean)

    %%plot negative up for EEG
    if strcmp(dataType,'eeg') 
        goodDataMean = -goodDataMean;
    end

    %%write epochs to 'blank' fif structure
    for y = 1:condNum
        newStr.evoked(y).epochs(:,:) = goodDataMean(:,:,y);
        newStr.evoked(y).nave = epCount(y);
    end

    outFile = strcat(dataPath,'ga/ga_ave_',exp,'_',dataType,'-n',int2str(count),'-goodC-ave.fif')
    fiff_write_evoked(outFile,newStr);

end
