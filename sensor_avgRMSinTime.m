function [allData] = sensor_avgRMSinTime(exp,subjGroup,listPrefix,gradType, condNum, t1, t2)


[allC,allC_rmsL,allC_rmsR] = sensor_rms_hem(exp,subjGroup,listPrefix,gradType);

filePrefix = strcat(exp,'_c',int2str(condNum),'_rms_',gradType);


[allData] = sensor_hemAvginTime(exp,subjGroup,listPrefix,filePrefix, allC_rmsL(:,:,condNum), allC_rmsR(:,:,condNum), t1, t2);