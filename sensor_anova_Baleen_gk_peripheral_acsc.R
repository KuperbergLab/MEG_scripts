sensor_anova_Baleen_gk_peripheral_acsc <-function(acfilePrefix,scfilePrefix,t1,t2){

library('ez')
options(digits=2)

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,acfilePrefix,".BaleenLP_All.gk_peripheral.",t1,"-",t2,".df",sep=""))
erpData.LP.ac.all <- erpData.all
load(paste(filePath,acfilePrefix,".BaleenHP_All.gk_peripheral.",t1,"-",t2,".df",sep=""))
erpData.HP.ac.all <- erpData.all
load(paste(filePath,scfilePrefix,".BaleenLP_All.gk_peripheral.",t1,"-",t2,".df",sep=""))
erpData.LP.sc.all <- erpData.all
load(paste(filePath,scfilePrefix,".BaleenHP_All.gk_peripheral.",t1,"-",t2,".df",sep=""))
erpData.HP.sc.all <- erpData.all

#combine LP and HP datasets for SC and AC
erpData.all <-rbind(erpData.LP.ac.all,erpData.HP.ac.all,erpData.LP.sc.all,erpData.HP.sc.all)



#more transparent factor labels
colnames(erpData.all)[3] <- "prop"
colnames(erpData.all)[4] <- "prime"

#get rid of bad channels T9, T10, TP9 and TP10
erpData.all <- subset(erpData.all,elec !=29 & elec != 39 & elec !=40 & elec !=50)

outfile <-paste(filePath,"acsc.Baleen_All.",t1,"-",t2,"_anova_gk_peripheral.txt",sep="")
sink(outfile);

################################################################
#############QUADRANT ANALYSIS##################################
################################################################


#Just get those electrodes that are in the defined groups
erpData.quad <-subset(erpData.all, hemCode != 'XX')
erpData.quad <- droplevels(erpData.quad)

#####Omnibus ANOVA######

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad,dv = .(amp),wid=.(subj),within=.(prime,prop,hemCode,antCode),between=.(subjGroup),type=3,detailed=TRUE)

#print results to file
print("All")
print(eztest)

#####Within Low Proportion ANOVA####

erpData.quad.lo <- subset(erpData.quad, prop == 'BaleenLP_All')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.lo,dv = .(amp),wid=.(subj),within=.(prime,hemCode,antCode),between=.(subjGroup),type=3,detailed=TRUE)

#print results to file
print("LowProp - Related vs. Unrelated")
print(eztest)

#####Within High Proportion ANOVA####

erpData.quad.hi <- subset(erpData.quad, prop == 'BaleenHP_All')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.hi,dv = .(amp),wid=.(subj),within=.(prime,hemCode,antCode),between=.(subjGroup),type=3,detailed=TRUE)

#print results to file
print("HighProp - Related vs. Unrelated")
print(eztest)


#####Within Anterior ANOVA####

erpData.quad.frontal <- subset(erpData.quad, antCode == 'frontal')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.frontal,dv = .(amp),wid=.(subj),within=.(prime,prop,hemCode),between=.(subjGroup),type=3,detailed=TRUE)

#print results to file
print("frontal")
print(eztest)

#####Within Posterior ANOVA####

erpData.quad.parietal <- subset(erpData.quad, antCode == 'parietal')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.parietal,dv = .(amp),wid=.(subj),within=.(prime,prop,hemCode),between=.(subjGroup),type=3,detailed=TRUE)

#print results to file
print("parietal")
print(eztest)

#####Within Left ANOVA####

erpData.quad.left <- subset(erpData.quad, hemCode == 'left')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left,dv = .(amp),wid=.(subj),within=.(prime,prop,antCode),between=.(subjGroup),type=3,detailed=TRUE)

#print results to file
print("Left")
print(eztest)

#####Within Right ANOVA####

erpData.quad.right <- subset(erpData.quad, hemCode == 'right')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right,dv = .(amp),wid=.(subj),within=.(prime,prop,antCode),between=.(subjGroup),type=3,detailed=TRUE)

#print results to file
print("Right")
print(eztest)


#####Within Left, Within Anterior ANOVA####

erpData.quad.left.frontal <- subset(erpData.quad, antCode == 'frontal' & hemCode == 'left')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left.frontal,dv = .(amp),wid=.(subj),within=.(prime,prop),between=.(subjGroup),type=3,detailed=TRUE)

#print results to file
print("Left frontal")
print(eztest)

#####Within Left, Within Posterior ANOVA####

erpData.quad.left.parietal <- subset(erpData.quad, antCode == 'parietal' & hemCode == 'left')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left.parietal,dv = .(amp),wid=.(subj),within=.(prime,prop),between=.(subjGroup),type=3,detailed=TRUE)

#print results to file
print("Left parietal")
print(eztest)

#####Within Right, Within Anterior ANOVA####

erpData.quad.right.frontal <- subset(erpData.quad, antCode == 'frontal' & hemCode == 'right')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right.frontal,dv = .(amp),wid=.(subj),within=.(prime,prop),between=.(subjGroup),type=3,detailed=TRUE)

#print results to file
print("Right frontal")
print(eztest)

#####Within Right, Within Posterior ANOVA####

erpData.quad.right.parietal <- subset(erpData.quad, antCode == 'parietal' & hemCode == 'right')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right.parietal,dv = .(amp),wid=.(subj),within=.(prime,prop),between=.(subjGroup),type=3,detailed=TRUE)

#print results to file
print("Right parietal")
print(eztest)


########
#Print the marginal means
erpData.quad.aov <- aov(amp ~ prime * prop * hemCode * antCode  + Error(subj/(prime * prop * hemCode * antCode)),data=erpData.quad)
print("Marginal Means")
print(model.tables(erpData.quad.aov,"means"),digits=5)


sink()


}
