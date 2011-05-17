function avgAcrossSubjs(exp)

%%%Currently does remove bad channels from image
dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

if (strcmp(exp,'BaleenHP_All') || strcmp(exp,'BaleenLP_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.baleen.meg-mri.txt');
elseif (strcmp(exp,'MaskedMM_All'))
    subjList = dlmread('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ya.masked.meg-mri.txt');
end
subjList = subjList'

for x = 1:2
    if x == 1
        dataType = 'projoff';
    else
        dataType = 'projon';
    end

    %%Get a template fif structure from random subject average
    blankStr = fiff_read_evoked_all(strcat(dataPath,'ya17/ave_',dataType,'/ya17_',exp,'-ave.fif'));
    condNum = size(blankStr.evoked,2);
    if strcmp(exp, 'ATLLoc') condNum = 3; end  %%don't want to try to average the whole-sentence epochs

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

    epCount;

    %%Since the good channels are the same across conditions, cut redundant
    %%columns to a single 390 x 1 matrix
    goodDataCount = goodDataCount(:,1);
    goodDataCount'

    %%Now repeat this 390 x 1 matrix by number of samples and conditions to get
    %%equivalent dimension matrix
    goodDataCountRep = repmat(goodDataCount,[1,sampleNum,condNum]);

    %%Finally, array-divide them
    goodDataMean = goodDataSum./goodDataCountRep;
    size(goodDataMean)

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

    %%%%ALTERNATIVE METHOD%%%%

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
