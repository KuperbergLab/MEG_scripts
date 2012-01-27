sensor_anova_midline_Masked <-function(filePrefix,t1,t2){
	
library('ez')

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,filePrefix,"MaskedMM_All.",t1,"-",t2,".df",sep=""))
outfile <-paste(filePath,filePrefix,"MaskedMM_All.",t1,"-",t2,"_mid_av.txt",sep="")
sink(outfile);
	
	
#start with all the electrodes in both midlines
erpData.mid <-subset(erpData.all, hemCode == 0 & elec != 28 & elec != 29 & elec != 39 & elec !=40)

######MIDV############################
##get out the midV
erpData.midV <-subset(erpData.mid, elec == 2 | elec == 6 | elec == 13 | elec == 23 | elec == 34 | elec == 45 | elec == 56 | elec == 64 | elec == 68 | elec == 70)

erpData.midV$ant <-factor(erpData.midV$elec)
levels(erpData.midV$ant)<-c("A","A","A","A","A","P","P","P","P","P")

#####Omnibus ANOVA######

#compute the ANOVA
eztest <- ezANOVA(data=erpData.midV,dv = .(amp),wid=.(subj),within=.(cond,ant),type=3,detailed=TRUE)

#print results to file
print("midV")
print(eztest)

#Print the marginal means
erpData.midV.aov <- aov(amp ~ cond * ant + Error(subj/(cond * ant)),data=erpData.midV)
print("Marginal Means")
print(model.tables(erpData.midV.aov,"means"),digits=5)

######HORV############################
##get out the midH
erpData.midH <-subset(erpData.mid, elec == 30 | elec == 31 | elec == 32 | elec == 33 | elec == 35 | elec == 36 | elec == 37 | elec == 38 )

erpData.midH$hem <-factor(erpData.midH$elec)
levels(erpData.midH$hem)<-c("L","L","L","L","R","R","R","R")

#####Omnibus ANOVA######

#compute the ANOVA
eztest <- ezANOVA(data=erpData.midH,dv = .(amp),wid=.(subj),within=.(cond,hem),type=3,detailed=TRUE)

#print results to file
print("midH")
print(eztest)

#Print the marginal means
erpData.midH.aov <- aov(amp ~ cond * hem + Error(subj/(cond * hem)),data=erpData.midH)
print("Marginal Means")
print(model.tables(erpData.midH.aov,"means"),digits=5)

sink()
	}