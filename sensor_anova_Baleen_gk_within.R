sensor_anova_Baleen_gk_within <-function(filePrefix,t1,t2){

library('ez')
options(digits=2)

#open output file
outfile <-paste(filePath,filePrefix,".Baleen_All.",t1,"-",t2,"_anova_gk.txt",sep="")
sink(outfile);

################################################################
##############MIDLINE ANALYSIS##################################
################################################################

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,filePrefix,".BaleenLP_All.gk_midline.",t1,"-",t2,".df",sep=""))
erpData.LP.all <- erpData.all
load(paste(filePath,filePrefix,".BaleenHP_All.gk_midline.",t1,"-",t2,".df",sep=""))
erpData.HP.all <- erpData.all

#combine LP and HP datasets
erpData.all <-rbind(erpData.LP.all,erpData.HP.all)

#more transparent factor labels
colnames(erpData.all)[3] <- "prop"
colnames(erpData.all)[4] <- "prime"

#get rid of channels that are not in the gk_midline regions
erpData.gk_mid <- subset(erpData.all, apCode != 'XX')
erpData.gk_mid <- droplevels(erpData.gk_mid)


print("")
print("*****Midline ANOVAS******")
print("")




#####Omnibus ANOVA######
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_mid,dv = .(amp),wid=.(subj),within=.(prime,prop,apCode),type=3,detailed=TRUE)
#print results to file
print("All")
print(eztest)

#####Within Low Proportion ANOVA####
#subset data
erpData.gk_mid.lo <- subset(erpData.gk_mid, prop == 'BaleenLP_All')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_mid.lo,dv = .(amp),wid=.(subj),within=.(prime,apCode),type=3,detailed=TRUE)
#print results to file
print("LowProp - Related vs. Unrelated")
print(eztest)

#####High Proportion ANOVA####
#subset data
erpData.gk_mid.hi <- subset(erpData.gk_mid, prop == 'BaleenHP_All')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_mid.hi,dv = .(amp),wid=.(subj),within=.(prime,apCode),type=3,detailed=TRUE)
#print results to file
print("HighProp - Related vs. Unrelated")
print(eztest)

#####Within Related ANOVA####
#subset data
erpData.gk_mid.rel <- subset(erpData.gk_mid, prime == 'Related')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_mid.rel,dv = .(amp),wid=.(subj),within=.(prop,apCode),type=3,detailed=TRUE)
#print results to file
print("Related - LoProp vs. HiProp")
print(eztest)

#####Within Unrelated ANOVA####
#subset data
erpData.gk_mid.unrel <- subset(erpData.gk_mid, prime == 'Unrelated')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_mid.unrel,dv = .(amp),wid=.(subj),within=.(prop,apCode),type=3,detailed=TRUE)
#print results to file
print("Unrelated - LoProp vs. HiProp")
print(eztest)

print("")
print("*****Individual ANOVAS******")
print("")


#####Within Frontal Frontal ANOVA####
#subset data
erpData.gk_mid.frontal_frontal <- subset(erpData.gk_mid, chanLabel == 'gk_frontal_frontal')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_mid.frontal_frontal,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)
#print results to file
print("Anterior frontal")
print(eztest)

#####Within Frontal Central ANOVA####
#subset data
erpData.gk_mid.frontal_central <- subset(erpData.gk_mid, chanLabel == 'gk_frontal_central')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_mid.frontal_central,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)
#print results to file
print("Frontal")
print(eztest)

#####Within Central ANOVA####
#subset data
erpData.gk_mid.central_central <- subset(erpData.gk_mid, chanLabel == 'gk_central_central')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_mid.central_central,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)
#print results to file
print("Central")
print(eztest)

#####Within Central Posterior ANOVA####
#subset data
erpData.gk_mid.parietal_central <- subset(erpData.gk_mid, chanLabel == 'gk_parietal_central')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_mid.parietal_central,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)
#print results to file
print("Central Posterior")
print(eztest)

#####Within Posterior ANOVA####
#subset data
erpData.gk_mid.occipital_central <- subset(erpData.gk_mid, chanLabel == 'gk_occipital_central')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_mid.occipital_central,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)
#print results to file
print("Posterior")
print(eztest)


################################################################
#############PERIPHERl ANALYSIS#################################
################################################################

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,filePrefix,".BaleenLP_All.gk_peripheral.",t1,"-",t2,".df",sep=""))
erpData.LP.all <- erpData.all
load(paste(filePath,filePrefix,".BaleenHP_All.gk_peripheral.",t1,"-",t2,".df",sep=""))
erpData.HP.all <- erpData.all

#combine LP and HP datasets
erpData.all <-rbind(erpData.LP.all,erpData.HP.all)

#more transparent factor labels
colnames(erpData.all)[3] <- "prop"
colnames(erpData.all)[4] <- "prime"

#get rid of channels that are not in the gk_peripheral regions
erpData.gk_per <- subset(erpData.all, hemCode != 'XX')
erpData.gk_per <- droplevels(erpData.gk_per)

print("")
print("*****Peripheral ANOVAS******")
print("")

#####Omnibus ANOVA######
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_per,dv = .(amp),wid=.(subj),within=.(prime,prop,hemCode,antCode),type=3,detailed=TRUE)
#print results to file
print("All")
print(eztest)

#####Within Low Proportion ANOVA####
#subset data
erpData.gk_per.lo <- subset(erpData.gk_per, prop == 'BaleenLP_All')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_per.lo,dv = .(amp),wid=.(subj),within=.(prime,hemCode,antCode),type=3,detailed=TRUE)
#print results to file
print("LowProp - Related vs. Unrelated")
print(eztest)

#####High Proportion ANOVA####
#subset data
erpData.gk_per.hi <- subset(erpData.gk_per, prop == 'BaleenHP_All')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_per.hi,dv = .(amp),wid=.(subj),within=.(prime,hemCode,antCode),type=3,detailed=TRUE)
#print results to file
print("HighProp - Related vs. Unrelated")
print(eztest)

#####Within Related ANOVA####
#subset data
erpData.gk_per.rel <- subset(erpData.gk_per, prime == 'Related')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_per.rel,dv = .(amp),wid=.(subj),within=.(prop,hemCode,antCode),type=3,detailed=TRUE)
#print results to file
print("Related - LoProp vs. HiProp")
print(eztest)

#####Within Unrelated ANOVA####
#subset data
erpData.gk_per.unrel <- subset(erpData.gk_per, prime == 'Unrelated')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_per.unrel,dv = .(amp),wid=.(subj),within=.(prop,hemCode,antCode),type=3,detailed=TRUE)
#print results to file
print("Unrelated - LoProp vs. HiProp")
print(eztest)

print("")
print("*****Individual ANOVAS******")
print("")

#####Within Anterior ANOVA####
#subset data
erpData.gk_per.frontal <- subset(erpData.gk_per, antCode == 'frontal')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_per.frontal,dv = .(amp),wid=.(subj),within=.(prime,prop,hemCode),type=3,detailed=TRUE)
#print results to file
print("frontal")
print(eztest)

#####Within Posterior ANOVA####
#subset data
erpData.gk_per.parietal <- subset(erpData.gk_per, antCode == 'parietal')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_per.parietal,dv = .(amp),wid=.(subj),within=.(prime,prop,hemCode),type=3,detailed=TRUE)
#print results to file
print("parietal")
print(eztest)

#####Within Left, Within Anterior ANOVA####
#subset data
erpData.gk_per.frontalL <- subset(erpData.gk_per, antCode == 'frontal' & hemCode == 'left')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_per.frontalL,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)
#print results to file
print("Left frontal")
print(eztest)

#####Within Left, Within Posterior ANOVA####
#subset data
erpData.gk_per.parietalL <- subset(erpData.gk_per, antCode == 'parietal' & hemCode == 'left')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_per.parietalL, dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)
#print results to file
print("Left parietal")
print(eztest)

#####Within Right, Within Anterior ANOVA####
#subset data
erpData.gk_per.frontalR <- subset(erpData.gk_per, antCode == 'frontal' & hemCode == 'right')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_per.frontalR,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)
#print results to file
print("Right frontal")
print(eztest)

#####Within Right, Within Posterior ANOVA####
#subset data
erpData.gk_per.parietalR <- subset(erpData.gk_per, antCode == 'parietal' & hemCode == 'right')
#compute the ANOVA
eztest <- ezANOVA(data=erpData.gk_per.parietalR,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)
#print results to file
print("Right parietal")
print(eztest)


########
#Print the marginal means
erpData.gk_per.aov <- aov(amp ~ prime * prop * hemCode * antCode + Error(subj/(prime * prop * hemCode * antCode)),data=erpData.gk_per)
print("Marginal Means")
print(model.tables(erpData.gk_per.aov,"means"),digits=5)


sink()


}
