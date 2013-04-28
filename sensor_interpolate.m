%%sensor_interpolate.m: intrepolates data from the EEG channels. Result is saved with the -I tag. 
%%Usage: sensor_interpolate("Expname', 'subjType', 'listPrefix')
%%Eg: sensor_interpolate('MaskedMM_All', 'ac', 'ac.meg.all')

function sensor_interpolate(exp,subjGroup,listPrefix)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
disp(dataPath);
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
newsubjList = {'ac31', 'sc19','sc20', 'sc21', 'sc22'};

numChan = 70;
disp(dataPath);
tic;
for s = subjList

    fileName = strcat(dataPath,'data/', subjGroup,int2str(s),'/ave_projon/',subjGroup,int2str(s),'_',exp,'-ave.fif');
    subjStr = fiff_read_evoked_all(fileName); %%this holds the original data
    iStr = subjStr; %%this will hold the interpolated data
 
    %% Read channel info

    allChans = [316:375 379:388];
    disp(s)
    %%fix subjects with different number of channels recorded
    if (s == 1 || s == 2 || s == 3 || s == 4) && strcmp(subjGroup,'ya')
        allChans = [316:375 380:389];
    end
    
    subjID = strcat(subjGroup, int2str(s));
    disp(subjID);
    %%fix subjects acquired after new MEG system(OCT 2012) - different order of MEG, EEG and STI channels recorded 
    if ismember(subjID, newsubjList)
            allChans = [307:366 370:379];
    end
      
    allX = [];
    allY = [];
    allZ = [];
    goodX = [];
    goodY = [];
    goodZ = [];
    goodChanIndex = [];
    badChanList = [];

    for i = 1:70
        allX(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(1);
        allY(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(2);
        allZ(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(3);
        badTest = find(strcmp(subjStr.info.bads,subjStr.info.ch_names{allChans(i)}));
        
        if size(badTest,2) == 0
            goodX(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(1);
            goodY(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(2);
            goodZ(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(3);
            goodChanIndex(end+1) = i;
        else
            badChanList(end+1) = badTest;%%make a list of bad EEG chan
        end
    end
    %%Manually entering X,Y,Z coordinates for 3 electrodes(OZ, O2, IZ) for sc19 since they are recorded as 0. 
    if (s==19) && strcmp(subjGroup, 'sc')
        allX(68) = 0.01;
        allY(68) = -0.85;
        allZ(68) = 0.1;
        allX(69) = 0.015;
        allY(69) = -0.90;
        allZ(69) = 0.9;
        allX(70) = 0.02;
        allY(70) = -0.10;
        allZ(70) = 0.8;
        goodX(66) = 0.01;
        goodY(66) = -0.85;
        goodZ(66) = 0.1;
        goodChanIndex(66) = 68;
        goodX(67) = 0.015;
        goodY(67) = -0.90;
        goodZ(67) = 0.9;
        goodChanIndex(67) = 69;
        goodX(68) = 0.02;
        goodY(68) = -0.10;
        goodZ(68) = 0.8;
        goodChanIndex(68) = 70;
    end
    

    
    goodChans = allChans(goodChanIndex);  %%goodChans is in MNE indices (316-389)
    goodPos = [goodX;goodY;goodZ];
    allPos = [allX;allY;allZ];
    badChanList
    iStr.info.bads(badChanList) = [];  %unmark the bad EEG chan in the interp. structure

    %% Make a triangulation of the positions    
    allTri = pos2tri(allPos);    
    goodTri = pos2tri(goodPos);
    
    %% Interpolate at each time point in each condition

    numConditions = size(subjStr.evoked,2);
    if strcmp(exp, 'ATLLoc') numConditions = 3; end

    numSamples = size(subjStr.evoked(1).epochs,2);

    for c = 1:numConditions
        c
        iData = zeros(numChan,numSamples);
        t = 1:numSamples;
        goodData = (subjStr.evoked(c).epochs(goodChans,:));
        iData(:,t) = interpolatedvoltages(allPos,allTri,goodPos,goodTri,goodData(:,t));
        iStr.evoked(c).epochs(allChans,:) = iData(:,:);
    end
    size(iData)

    outFileName = strcat(dataPath,'data/',subjGroup,int2str(s),'/ave_projon/',subjGroup,int2str(s),'_',exp,'-I-ave.fif');
    fiff_write_evoked(outFileName,iStr);
%     
end
 toc;
% 
% 
%     
