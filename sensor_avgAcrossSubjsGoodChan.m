function sensor_avgAcrossSubjsGoodChan(exp,listPrefix)

%%Ellen Lau%%
%%This outputs grand-average evoked files for viewing in
%%mne_browse_raw. 

%%This outputs files for MEG only. Different from the
%%sensor_avgAcrossSubjs.m script, this script includes only 'good' channels
%%in the average
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
tempSubj= (dlmread(strcat(dataPath,'scripts/function_inputs/ac.meg.31.txt')))';
numSubj = size(subjList,2);

%%%%Getting the data out

load(strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix, '_',exp, '_projon.mat'));
dataType = 'meg';
numChan = 380;
chanV = 1:380;


%%Get a template fif structure from random subject average, and modify
%%it to delete the irrelevant channels from the structure
for subj=tempSubj
        load(strcat(dataPath, 'results/sensor_level/ave_mat/ac.meg.31_',exp, '_projoff.mat')); %%Using the template ac31  to accomodate for the change in ac, sc data structure - EEG channels(307-380) in new subjects and (316-389) in old subjects(STI(307-315) deleted)
        newStr = TempSubjData{1};    
end

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

allData=zeros(numChan,numSample,numCond,numSubj);
epCount=zeros(numCond,1);
goodDataSum=zeros(numChan,numSample,numCond);
goodDataCount = zeros(numChan,numCond);
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
        
        %%%Good channel average%%%
        countG = 0;
        for iChan = chanV
            countG = countG+1;
            sensName = subjStr.info.ch_names{iChan};
            badTest = find(strcmp(subjStr.info.bads, sensName));
            if size(badTest,2) == 1
                sensName;
            end
        
            if size(badTest,2) == 0
                iChan;
                size(epData);
                size(goodDataSum);
                goodDataSum(countG,:,c) = goodDataSum(countG,:,c) + epData(iChan,:);
                goodDataCount(countG,c) = goodDataCount(countG,c)+1;
            end
        end

    end

end


%%COMPUTING THE 'GOOD CHANNEL' GRAND-AVERAGE
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


%%write epochs to 'blank' fif structure
for y = 1:numCond
    newStr.evoked(y).epochs(:,:) = goodDataMean(:,:,y);
    newStr.evoked(y).nave = epCount(y);
end
outFile = strcat(dataPath,'results/sensor_level/ga_fif/ga_',listPrefix,'_',exp,'_',dataType,'-goodC-ave.fif')
fiff_write_evoked(outFile,newStr);

