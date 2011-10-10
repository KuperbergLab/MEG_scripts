function [allData] = sensor_hemAvginTime(exp,subjGroup,listPrefix,filePrefix, dataL, dataR, t1, t2)

%%This script is designed to read in any two timecourses, one from each hem
%%for each subject, takes a mean across a selected time window, and outputs
%%the result to a textfile that has three columns: the L value, the R value
%%and the L-R subtraction


sample1 = round(t1/1.6666 + 61);
sample2 = round(t2/1.6666 + 61);

winL = mean(dataL(sample1:sample2,:),1)';
winR = mean(dataR(sample1:sample2,:),1)';
winL_R = winL-winR;

allData= winL;
allData(:,2) = winR;
allData(:,3) = winL_R;

outFile = strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/hem_measures/',listPrefix,filePrefix,'.',int2str(t1),'-',int2str(t2),'.txt');

dlmwrite(outFile,allData,'\t');


