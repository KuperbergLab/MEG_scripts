function setupEEGChanGroups(chanGroupList,groupFactor,matFileName)

%%EXample:
%%setupEEGChanGroups({'left_ant','right_ant','left_post','right_post'},{{'left','right','left','right'},{'ant','ant','post','post'}},'quad48')

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
outFileName = strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/',matFileName,'.mat')
numChan = 70;
chan = [307:366 370:379]; %Not including the STI channels and RMAST 1/11/13

%chanGroupList = {'left_ant','right_ant','left_post','right_post'}
%groupFactor = {{'left','right','left','right'},{'ant','ant','post','post'}}
chanArray = {};
regionV = cell(1,numChan);

for cg = 1:size(chanGroupList,2)
    fileName = strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/EEG_Chan_Names/',chanGroupList{cg},'.txt');
    chanArray{cg} = dlmread(fileName);
end

for x = 1:numChan
    currChan = x;
    if x > 60 currChan = x+4;end
    for cg = 1:size(chanGroupList,2)
        if find(chanArray{cg}==currChan) regionV{x} = chanGroupList{cg};
        end
    end
    if isempty(regionV{x}) regionV{x} = 'XX';end

end

%%assign the grouping factors to each channel
chanGroupArray = {};
groupCount = 0;
for x = 1:size(groupFactor,2)
    groupCount = groupCount+1;
    tempA = {};
    for y = 1:numChan
        if ~strcmp(regionV{y},'XX')
            pos = strmatch(regionV{y},chanGroupList,'exact');
            tempA{y} = groupFactor{x}{pos};
        else
            tempA{y} = 'XX';
        end
    end

    chanGroupArray{x} = tempA;
end

chanGroupArray{end+1} = regionV;
save(outFileName,'chanGroupArray');