function avgAcrossSubjs(exp)

%%This outputs two types of grand-average evoked files for viewing in
%%mne_browse_raw. The first one is a straight average, and the second one
%%'goodC' is an average that selectively excludes bad channels in
%%individuals from the average. This one is cleaner but of course it has
%%different numbers of observations going into different channels.

%%This outputs a separate set of files with projections on and off. The
%%'projoff' is designed only for viewing the G-A EEG data, and for
%%comparison with standard language ERPs, it flips the polarity of the
%%signals. Therefore you should NEVER view the MEG G-A for projoff, because
%%it will have the field maps flipped

%%%Selecting data path and subject%%%%

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

if (strcmp(exp,'BaleenHP_All') || strcmp(exp,'BaleenLP_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.baleen.meg-mri.txt');
elseif (strcmp(exp,'MaskedMM_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.masked.meg-mri.txt');
end
subjList = subjList'


%%%%Getting the data out, loop once each for projon and projoff

for x = 1:2
    if x == 1
        dataType = 'projoff';
    else
        dataType = 'projon';
    end

    %%Get a template fif structure from random subject average
    blankStr = fiff_read_evoked_all(strcat(dataPath,'ya17/ave_',dataType,'/ya17_',exp,'-ave.fif'));
    condNum = size(blankStr.evoked,2);
    
    %%don't want to try to average the whole-sentence epochs
    if strcmp(exp, 'ATLLoc') condNum = 3; end  

    %%Initialize variables
    sampleNum = size(blankStr.evoked(1).epochs,2)
    chanNum = 390;
    count = 0;
    allData=[];
    goodDataSum =zeros(chanNum,sampleNum,condNum);
    goodDataCount = zeros(chanNum,condNum);
    epCount=zeros(condNum,1);

    %%for each subject, get the evoked data out
    for subj=subjList
        count=count+1
        subj

        %%Read in ave fif file for subject
        filename = strcat(dataPath,'ya',int2str(subj),'/ave_',dataType,'/','ya',int2str(subj),'_',exp,'-ave.fif')
        tempStr = fiff_read_evoked_all(filename);

        %%For each condition, get the evoked data out
        for x = 1:condNum
            temp = tempStr.evoked(x).epochs(:,:);

            %%Get rid of junk channels accidentally acquired in first subjects
            %%so matrices match up
            if (subj == 1 || subj == 3 || subj == 4 || subj == 7)
                temp(390,:) = [];
                temp(379,:) = [];
            end

            %%sensor x time x condition structure for subject data
            tempEv(:,:,x) = temp;

            %%running count of how many epochs went into grand-average
            epCount(x) = epCount(x) + tempStr.evoked(x).nave;

            %%%%GETTING RID OF BAD CHANNELS IN GRAND-AVERAGE%%%%

            for iChan = 1:chanNum
                sensName = tempStr.info.ch_names{iChan};
                badTest = find(strcmp(tempStr.info.bads, sensName));
                if size(badTest,2) == 1 
                    sensName;
                end

                if size(badTest,2) == 0
                    goodDataSum(iChan,:,x) = goodDataSum(iChan,:,x) + temp(iChan,:);
                    goodDataCount(iChan,x) = goodDataCount(iChan,x)+1;
                end
            end

        end

        %%sensor x time x condition x subject structure
        allData(:,:,:,count) = tempEv;
        size(allData)
        clear('tempEv');
        clear('tempRunStr');


    end
    
    %%%COMPUTING REGULAR GRAND-AVERAGE%%%%

    gaData = mean(allData,4);

    %%plot negative up for EEG
    if strcmp(dataType,'projoff') 
        gaData = -gaData;
    end

    %%write epochs to 'blank' fif structure
    for y = 1:condNum
        blankStr.evoked(y).epochs(:,:) = gaData(:,:,y);
        blankStr.evoked(y).nave = epCount(y);
    end

    outFile = strcat(dataPath,'ga/ave_',dataType,'ga_',exp,'-n',int2str(count),'-ave.fif')
    fiff_write_evoked(outFile,blankStr);

    
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
    if strcmp(dataType,'projoff') 
        goodDataMean = -goodDataMean;
    end

    %%write epochs to 'blank' fif structure
    for y = 1:condNum
        blankStr.evoked(y).epochs(:,:) = goodDataMean(:,:,y);
        blankStr.evoked(y).nave = epCount(y);
    end

    outFile = strcat(dataPath,'ga/ave_',dataType,'ga_',exp,'-n',int2str(count),'-goodC-ave.fif')
    fiff_write_evoked(outFile,blankStr);

end
