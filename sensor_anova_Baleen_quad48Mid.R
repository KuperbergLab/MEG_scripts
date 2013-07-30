sensor_anova_Baleen_quad48Mid <-function(filePrefix,t1,t2){

library('ez')
options(digits=2)

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,filePrefix,".BaleenLP_All.quad48Mid.",t1,"-",t2,".df",sep=""))
erpData.LP.all <- erpData.all
load(paste(filePath,filePrefix,".BaleenHP_All.quad48Mid.",t1,"-",t2,".df",sep=""))
erpData.HP.all <- erpData.all

#combine LP and HP datasets
erpData.all <-rbind(erpData.LP.all,erpData.HP.all)

#more transparent factor labels
colnames(erpData.all)[3] <- "prop"
colnames(erpData.all)[4] <- "prime"

#get rid of bad channels T9, T10, TP9 and TP10
erpData.all <- subset(erpData.all,elec !=29 & elec != 39 & elec !=40 & elec !=50)

outfile <-paste(filePath,filePrefix,".Baleen_All.",t1,"-",t2,"_anova_quad48Mid.txt",sep="")
sink(outfile);

################################################################
#############QUADRANT ANALYSIS##################################
################################################################


#Just get those 48 electrodes that are in the defined quadrants
erpData.quad <-subset(erpData.all, hemCode != 'XX')
erpData.quad <- droplevels(erpData.quad)

#####Omnibus ANOVA######

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad,dv = .(amp),wid=.(subj),within=.(prime,prop,hemCode,antCode),type=3,detailed=TRUE)

#print results to file
print("All")
print(eztest)

#####Within Low Proportion ANOVA####

erpData.quad.lo <- subset(erpData.quad, prop == 'BaleenLP_All')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.lo,dv = .(amp),wid=.(subj),within=.(prime,hemCode,antCode),type=3,detailed=TRUE)

#print results to file
print("Lo")
print(eztest)

#####Within High Proportion ANOVA####

erpData.quad.hi <- subset(erpData.quad, prop == 'BaleenHP_All')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.hi,dv = .(amp),wid=.(subj),within=.(prime,hemCode,antCode),type=3,detailed=TRUE)

#print results to file
print("Hi")
print(eztest)


#####Within Anterior ANOVA####

erpData.quad.ant <- subset(erpData.quad, antCode == 'ant')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.ant,dv = .(amp),wid=.(subj),within=.(prime,prop,hemCode),type=3,detailed=TRUE)

#print results to file
print("Ant")
print(eztest)

#####Within Posterior ANOVA####

erpData.quad.post <- subset(erpData.quad, antCode == 'post')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.post,dv = .(amp),wid=.(subj),within=.(prime,prop,hemCode),type=3,detailed=TRUE)

#print results to file
print("Post")
print(eztest)

#####Within Left ANOVA####

erpData.quad.left <- subset(erpData.quad, hemCode == 'left')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left,dv = .(amp),wid=.(subj),within=.(prime,prop,antCode),type=3,detailed=TRUE)

#print results to file
print("Left")
print(eztest)

#####Within Right ANOVA####

erpData.quad.right <- subset(erpData.quad, hemCode == 'right')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right,dv = .(amp),wid=.(subj),within=.(prime,prop,antCode),type=3,detailed=TRUE)

#print results to file
print("Right")
print(eztest)


#####Within Left, Within Anterior ANOVA####

erpData.quad.left.ant <- subset(erpData.quad, antCode == 'ant' & hemCode == 'left')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left.ant,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)

#print results to file
print("Left Ant")
print(eztest)

#####Within Left, Within Posterior ANOVA####

erpData.quad.left.post <- subset(erpData.quad, antCode == 'post' & hemCode == 'left')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left.post,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)

#print results to file
print("Left Post")
print(eztest)

#####Within Right, Within Anterior ANOVA####

erpData.quad.right.ant <- subset(erpData.quad, antCode == 'ant' & hemCode == 'right')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right.ant,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)

#print results to file
print("Right Ant")
print(eztest)

#####Within Right, Within Posterior ANOVA####

erpData.quad.right.post <- subset(erpData.quad, antCode == 'post' & hemCode == 'right')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right.post,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)

#print results to file
print("Right Post")
print(eztest)


########
#Print the marginal means
erpData.quad.aov <- aov(amp ~ prime * prop * hemCode * antCode + Error(subj/(prime * prop * hemCode * antCode)),data=erpData.quad)
print("Marginal Means")
print(model.tables(erpData.quad.aov,"means"),digits=5)

################################################################
#############MIDLINE ANALYSIS##################################
################################################################

		
#start with all the electrodes in both midlines
erpData.mid <-subset(erpData.all, hemCode == 'XX' & elec != 28 & elec != 29 & elec != 39 & elec !=40)

######MIDV############################
##get out the midV
erpData.midV <-subset(erpData.mid, elec == 2 | elec == 6 | elec == 13 | elec == 23 | elec == 34 | elec == 45 | elec == 56 | elec == 64 | elec == 68 | elec == 70)

erpData.midV$antCode <-factor(erpData.midV$elec)
levels(erpData.midV$antCode)<-c("ant","ant","ant","ant","ant","post","post","post","post","post")

#####Omnibus ANOVA######

#compute the ANOVA
eztest <- ezANOVA(data=erpData.midV,dv = .(amp),wid=.(subj),within=.(prime,prop,antCode),type=3,detailed=TRUE)

#print results to file
print("midV")
print(eztest)

#Print the marginal means
erpData.midV.aov <- aov(amp ~ prime * prop * antCode + Error(subj/(prime * prop * antCode)),data=erpData.midV)
print("Marginal Means")
print(model.tables(erpData.midV.aov,"means"),digits=5)

######HORV############################
##get out the midH
erpData.midH <-subset(erpData.mid, elec == 30 | elec == 31 | elec == 32 | elec == 33 | elec == 35 | elec == 36 | elec == 37 | elec == 38 )

erpData.midH$hemCode <-factor(erpData.midH$elec)
levels(erpData.midH$hemCode)<-c("left","left","left","left","right","right","right","right")

#####Omnibus ANOVA######

#compute the ANOVA
eztest <- ezANOVA(data=erpData.midH,dv = .(amp),wid=.(subj),within=.(prime,prop,hemCode),type=3,detailed=TRUE)

#print results to file
print("midH")
print(eztest)

#Print the marginal means
erpData.midH.aov <- aov(amp ~ prime * prop * hemCode + Error(subj/(prime * prop * hemCode)),data=erpData.midH)
print("Marginal Means")
print(model.tables(erpData.midH.aov,"means"),digits=5)

sink()


}
