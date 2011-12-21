anova_main <-function(filePrefix,t1,t2){

library('ez')

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,filePrefix,t1,"-",t2,".df",sep=""))
outfile <-paste(filePath,filePrefix,t1,"-",t2,"_main_av.txt",sep="")
sink(outfile);

#get rid of bad channels T9, T10, TP9 and TP10
erpData.all <- subset(erpData.all,elec !=29 & elec != 39 & elec !=40 & elec !=50)

eztest <-ezANOVA(data=erpData.all,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)

print(eztest)

#
###################
erpData.lo = subset(erpData.all, prop == 'lo')
erpData.hi = subset(erpData.all, prop == 'hi')
#

eztest <-ezANOVA(data=erpData.lo,dv = .(amp),wid=.(subj),within=.(prime),type=3,detailed=TRUE)

print("")
print("Low")
print(eztest)
#

eztest <-ezANOVA(data=erpData.hi,dv = .(amp),wid=.(subj),within=.(prime),type=3,detailed=TRUE)

print("")
print("High")
print(eztest)
#


##################
##Grab marginal means in a silly way
erpData.aov = aov(amp ~ prime * prop + Error(subj/(prime * prop)),data=erpData.all)

print(model.tables(erpData.aov, "means"), digits = 5)


sink();


}