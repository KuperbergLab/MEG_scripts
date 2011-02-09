for run = 1:4
    tempRunStr = fiff_read_evoked_all(strcat('ya3_BaleenRun',int2str(run),'-ave.fif'));
    RelEvLP(:,:,run) = tempRunStr.evoked(1).epochs(316:392,:);
    UnrelEvLP(:,:,run) = tempRunStr.evoked(2).epochs(316:392,:);
    ProbeEvLP(:,:,run) = tempRunStr.evoked(4).epochs(316:392,:);
end

for run = 5:8
    count = run-4
    tempRunStr = fiff_read_evoked_all(strcat('ya3_BaleenRun',int2str(run),'-ave.fif'));
    RelEvHP(:,:,count) = tempRunStr.evoked(1).epochs(316:392,:);
    UnrelEvHP(:,:,count) = tempRunStr.evoked(2).epochs(316:392,:);
    ProbeEvHP(:,:,count) = tempRunStr.evoked(5).epochs(316:392,:);
end

meanProbeEvHP = mean(ProbeEvHP,3);
meanProbeEvLP = mean(ProbeEvLP,3);
meanRelEvLP = mean(RelEvLP,3);
meanRelEvHP = mean(RelEvHP,3);
meanUnrelEvHP = mean(UnrelEvHP,3);
meanUnrelEvLP = mean(UnrelEvLP,3);

for y = 1:661
    
    meanProbeEvHP_bl(:,y) = meanProbeEvHP(:,y)-mean(meanProbeEvHP(:,1:60),2);
    meanProbeEvLP_bl(:,y) = meanProbeEvLP(:,y)-mean(meanProbeEvLP(:,1:60),2);    
    meanRelEvHP_bl(:,y) = meanRelEvHP(:,y)-mean(meanRelEvHP(:,1:60),2);    
    meanRelEvLP_bl(:,y) = meanRelEvLP(:,y)-mean(meanRelEvLP(:,1:60),2);
    meanUnrelEvHP_bl(:,y) = meanUnrelEvHP(:,y)-mean(meanUnrelEvHP(:,1:60),2);    
    meanUnrelEvLP_bl(:,y) = meanUnrelEvLP(:,y)-mean(meanUnrelEvLP(:,1:60),2);
end
