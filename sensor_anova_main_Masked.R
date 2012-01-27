sensor_anova_main_Masked <-function(filePrefix,t1,t2){

library('ez')

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,filePrefix,"MaskedMM_All.",t1,"-",t2,".df",sep=""))
outfile <-paste(filePath,filePrefix,"MaskedMM_All.",t1,"-",t2,"_main_av.txt",sep="")
sink(outfile);


#get rid of bad channels T9, T10, TP9 and TP10
erpData.all <- subset(erpData.all,elec !=29 & elec != 39 & elec !=40 & elec !=50)

#COMPUTE OVERALL ANOVA FOR 3 TARGET CONDITIONS
erpData.all <- subset(erpData.all, cond == 1 | cond == 2 | cond == 3)

eztest <-ezANOVA(data=erpData.all,dv = .(amp),wid=.(subj),within=.(cond),type=3,detailed=TRUE)
print("all 3 conditions")
print(eztest)


#COMPUTE PAIRED COMPARISON BETWEEN DIRECTLY RELATED (1) AND UNRELATED (3)
erpData.c1c3 <- subset(erpData.all, cond == 1 | cond == 3)

eztest <-ezANOVA(data=erpData.c1c3,dv = .(amp),wid=.(subj),within=.(cond),type=3,detailed=TRUE)
print("c1 vs. c3")
print(eztest)

#COMPUTE PAIRED COMPARISON BETWEEN INDIRECTLY RELATED (2) AND UNRELATED (3)
erpData.c2c3 <- subset(erpData.all, cond == 2 | cond == 3)

eztest <-ezANOVA(data=erpData.c2c3,dv = .(amp),wid=.(subj),within=.(cond),type=3,detailed=TRUE)
print("c2 vs. c3")
print(eztest)

##################
##Grab marginal means
erpData.aov = aov(amp ~ cond + Error(subj/(cond)),data=erpData.all)

print(model.tables(erpData.aov, "means"), digits = 5)


sink();


}