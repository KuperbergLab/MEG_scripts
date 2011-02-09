function avg_across_runs(subjID,dataType)

dataPath = strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/data/',subjID,'/ave_',dataType)

cd(dataPath)

%%%%MaskedMM runs%%%%%
blankStr = fiff_read_evoked_all(strcat(subjID,'_MaskedMMRun1-ave.fif'));
strSize = size(blankStr.evoked)
cond = strSize(2)
for run = 1:2
    tempRunStr = fiff_read_evoked_all(strcat(subjID,'_MaskedMMRun',int2str(run),'-ave.fif'));
        for x = 1:cond
            tempEv(:,:,x,run) = tempRunStr.evoked(x).epochs(:,:);
        end
end

meanTempEv = mean(tempEv,4);

for y = 1:cond
    blankStr.evoked(y).epochs(:,:) = meanTempEv(:,:,y);
end

outFile = strcat(subjID,'_MaskedMM_all-ave.fif')
fiff_write_evoked(outFile,blankStr);


%%%%%Low-Prop runs%%%%
blankStr = fiff_read_evoked_all(strcat(subjID,'_BaleenRun1-ave.fif'));
strSize = size(blankStr.evoked)
cond = strSize(2)
for run = 1:4
    tempRunStr = fiff_read_evoked_all(strcat(subjID,'_BaleenRun',int2str(run),'-ave.fif'));
    for x = 1:cond
        tempEv(:,:,x,run) = tempRunStr.evoked(x).epochs(:,:);
    end
end

meanTempEv = mean(tempEv,4);

for y = 1:cond
    blankStr.evoked(y).epochs(:,:) = meanTempEv(:,:,y);
end

outFile = strcat(subjID,'_Baleen_LP-ave.fif')
fiff_write_evoked(outFile,blankStr);

%%%%High-Prop runs%%%%
blankStr = fiff_read_evoked_all(strcat(subjID,'_BaleenRun5-ave.fif'));
strSize = size(blankStr.evoked)
cond = strSize(2)

for run = 5:8
    count = run-4
    tempRunStr = fiff_read_evoked_all(strcat(subjID,'_BaleenRun',int2str(run),'-ave.fif'));
    for x = 1:cond
        tempEv(:,:,x,run) = tempRunStr.evoked(x).epochs(:,:);
    end
end

meanTempEv = mean(tempEv,4);

for y = 1:cond
    blankStr.evoked(y).epochs(:,:) = meanTempEv(:,:,y);
end

outFile = strcat(subjID, '_Baleen_HP-ave.fif')
fiff_write_evoked(outFile,blankStr);