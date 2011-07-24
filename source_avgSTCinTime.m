function source_avgSTCinTime(filePrefix, type,t1,t2)

%%This script is simpler than most: it just takes a single stc file and
%%averages it across a time-window. 

sample1 = round(t1/1.6666 + 61);
sample2 = round(t2/1.6666 + 61);

for hemI = 1:2
    
    if hemI == 1
        hem = 'lh';
    elseif hemI == 2
        hem = 'rh';
    end

    stcStruct = mne_read_stc_file(strcat(filePrefix, '-',type,'-',hem,'.stc'));
    stcData = stcStruct.data;
    meanStcData = mean(stcData(:,sample1:sample2),2);

    outFile = strcat(filePrefix,'_',int2str(t1),'-',int2str(t2),'-',type,'-',hem,'.stc');

    newSTC = stcStruct;
    newSTC.data = meanStcData;

    mne_write_stc_file(outFile,newSTC);
end