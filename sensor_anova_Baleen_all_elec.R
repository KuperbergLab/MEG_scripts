sensor_anova_Baleen_all_elec <-function(filePrefix,chanGroupName,t1,t2){

library('ez')
options(digits=2)

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,filePrefix,".BaleenLP_All.",chanGroupName,".",t1,"-",t2,".df",sep=""))
erpData.LP.all <- erpData.all
load(paste(filePath,filePrefix,".BaleenHP_All.",chanGroupName,".",t1,"-",t2,".df",sep=""))
erpData.HP.all <- erpData.all

#combine LP and HP datasets
erpData.all <-rbind(erpData.LP.all,erpData.HP.all)

#more transparent factor labels
colnames(erpData.all)[3] <- "prop"
colnames(erpData.all)[4] <- "prime"

outfile <-paste(filePath,filePrefix,".Baleen_All.",chanGroupName,".",t1,"-",t2,"_anova_all_elec.txt",sep="")
sink(outfile);

#get rid of bad channels T9, T10, TP9 and TP10
erpData.all <- subset(erpData.all,elec !=29 & elec != 39 & elec !=40 & elec !=50)

eztest <-ezANOVA(data=erpData.all,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)
print(eztest)

#
###################
erpData.lo = subset(erpData.all, prop == 'BaleenLP_All')
erpData.hi = subset(erpData.all, prop == 'BaleenHP_All')
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
print("Marginal Means")
print(model.tables(erpData.aov, "means"), digits = 5)


sink();


}
