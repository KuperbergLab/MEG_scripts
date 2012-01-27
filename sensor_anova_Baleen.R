sensor_anova_Baleen <-function(filePrefix,t1,t2){

library('ez')

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,filePrefix,"Baleen_All.",t1,"-",t2,".df",sep=""))
outfile <-paste(filePath,filePrefix,"Baleen_All.",t1,"-",t2,"_main_av.txt",sep="")
sink(outfile);

erpData.all$prime<-factor(erpData.all$cond,exclude=NULL);
levels(erpData.all$prime)<-c("rel","unrel","rel","unrel");
erpData.all$prop<-factor(erpData.all$cond,exclude=NULL);
levels(erpData.all$prop)<-c("lo","lo","hi","hi");

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


################################################################
#############QUADRANT ANALYSIS##################################
################################################################

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,filePrefix,"Baleen_All.",t1,"-",t2,".df",sep=""))
outfile <-paste(filePath,filePrefix,"Baleen_All.",t1,"-",t2,"_quad_av.txt",sep="")
sink(outfile);

erpData.all$prime<-factor(erpData.all$cond,exclude=NULL);
levels(erpData.all$prime)<-c("rel","unrel","rel","unrel");
erpData.all$prop<-factor(erpData.all$cond,exclude=NULL);
levels(erpData.all$prop)<-c("lo","lo","hi","hi");	
	
	
#Just get those 48 electrodes that are in the defined quadrants
erpData.quad <-subset(erpData.all, hemCode != 0)

#get factors without 0 and relabel
erpData.quad$hem <-factor(erpData.quad$hemCode)
levels(erpData.quad$hem)<-c("L","R")
erpData.quad$ant <-factor(erpData.quad$antCode)
levels(erpData.quad$ant)<-c("A","P")

#####Omnibus ANOVA######

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad,dv = .(amp),wid=.(subj),within=.(prime,prop,hem,ant),type=3,detailed=TRUE)

#print results to file
print("All")
print(eztest)

#####Within Low Proportion ANOVA####

erpData.quad.lo <- subset(erpData.quad, prop == 'lo')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.lo,dv = .(amp),wid=.(subj),within=.(prime,hem,ant),type=3,detailed=TRUE)

#print results to file
print("Lo")
print(eztest)

#####Within High Proportion ANOVA####

erpData.quad.hi <- subset(erpData.quad, prop == 'hi')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.hi,dv = .(amp),wid=.(subj),within=.(prime,hem,ant),type=3,detailed=TRUE)

#print results to file
print("Hi")
print(eztest)


#####Within Anterior ANOVA####

erpData.quad.ant <- subset(erpData.quad, ant == 'A')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.ant,dv = .(amp),wid=.(subj),within=.(prime,prop,hem),type=3,detailed=TRUE)

#print results to file
print("Ant")
print(eztest)

#####Within Posterior ANOVA####

erpData.quad.post <- subset(erpData.quad, ant == 'P')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.post,dv = .(amp),wid=.(subj),within=.(prime,prop,hem),type=3,detailed=TRUE)

#print results to file
print("Post")
print(eztest)

#####Within Left ANOVA####

erpData.quad.left <- subset(erpData.quad, hem == 'L')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left,dv = .(amp),wid=.(subj),within=.(prime,prop,ant),type=3,detailed=TRUE)

#print results to file
print("Left")
print(eztest)

#####Within Right ANOVA####

erpData.quad.right <- subset(erpData.quad, hem == 'R')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right,dv = .(amp),wid=.(subj),within=.(prime,prop,ant),type=3,detailed=TRUE)

#print results to file
print("Right")
print(eztest)


#####Within Left, Within Anterior ANOVA####

erpData.quad.left.ant <- subset(erpData.quad, ant == 'A' & hem == 'L')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left.ant,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)

#print results to file
print("Left Ant")
print(eztest)

#####Within Left, Within Posterior ANOVA####

erpData.quad.left.post <- subset(erpData.quad, ant == 'P' & hem == 'L')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left.post,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)

#print results to file
print("Left Post")
print(eztest)

#####Within Right, Within Anterior ANOVA####

erpData.quad.right.ant <- subset(erpData.quad, ant == 'A' & hem == 'R')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right.ant,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)

#print results to file
print("Right Ant")
print(eztest)

#####Within Right, Within Posterior ANOVA####

erpData.quad.right.post <- subset(erpData.quad, ant == 'P' & hem == 'R')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right.post,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)

#print results to file
print("Right Post")
print(eztest)


########
#Print the marginal means
erpData.quad.aov <- aov(amp ~ prime * prop * hem * ant + Error(subj/(prime * prop * hem * ant)),data=erpData.quad)
print("Marginal Means")
print(model.tables(erpData.quad.aov,"means"),digits=5)
sink()

################################################################
#############MIDLINE ANALYSIS##################################
################################################################

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,filePrefix,"Baleen_All.",t1,"-",t2,".df",sep=""))
outfile <-paste(filePath,filePrefix,"Baleen_All.",t1,"-",t2,"_mid_av.txt",sep="")
sink(outfile);
	
	
erpData.all$prime<-factor(erpData.all$cond,exclude=NULL);
levels(erpData.all$prime)<-c("rel","unrel","rel","unrel");
erpData.all$prop<-factor(erpData.all$cond,exclude=NULL);
levels(erpData.all$prop)<-c("lo","lo","hi","hi");
	
#start with all the electrodes in both midlines
erpData.mid <-subset(erpData.all, hemCode == 0 & elec != 28 & elec != 29 & elec != 39 & elec !=40)

######MIDV############################
##get out the midV
erpData.midV <-subset(erpData.mid, elec == 2 | elec == 6 | elec == 13 | elec == 23 | elec == 34 | elec == 45 | elec == 56 | elec == 64 | elec == 68 | elec == 70)

erpData.midV$ant <-factor(erpData.midV$elec)
levels(erpData.midV$ant)<-c("A","A","A","A","A","P","P","P","P","P")

#####Omnibus ANOVA######

#compute the ANOVA
eztest <- ezANOVA(data=erpData.midV,dv = .(amp),wid=.(subj),within=.(prime,prop,ant),type=3,detailed=TRUE)

#print results to file
print("midV")
print(eztest)

#Print the marginal means
erpData.midV.aov <- aov(amp ~ prime * prop * ant + Error(subj/(prime * prop * ant)),data=erpData.midV)
print("Marginal Means")
print(model.tables(erpData.midV.aov,"means"),digits=5)

######HORV############################
##get out the midH
erpData.midH <-subset(erpData.mid, elec == 30 | elec == 31 | elec == 32 | elec == 33 | elec == 35 | elec == 36 | elec == 37 | elec == 38 )

erpData.midH$hem <-factor(erpData.midH$elec)
levels(erpData.midH$hem)<-c("L","L","L","L","R","R","R","R")

#####Omnibus ANOVA######

#compute the ANOVA
eztest <- ezANOVA(data=erpData.midH,dv = .(amp),wid=.(subj),within=.(prime,prop,hem),type=3,detailed=TRUE)

#print results to file
print("midH")
print(eztest)

#Print the marginal means
erpData.midH.aov <- aov(amp ~ prime * prop * hem + Error(subj/(prime * prop * hem)),data=erpData.midH)
print("Marginal Means")
print(model.tables(erpData.midH.aov,"means"),digits=5)

sink()

}