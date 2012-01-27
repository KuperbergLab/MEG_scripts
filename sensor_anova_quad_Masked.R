sensor_anova_quad_Masked <-function(filePrefix,t1,t2){

library('ez')

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
load(paste(filePath,filePrefix,"MaskedMM_All.",t1,"-",t2,".df",sep=""))
outfile <-paste(filePath,filePrefix,"MaskedMM_All.",t1,"-",t2,"_quad_av.txt",sep="")
sink(outfile);	
	
#Just get those 48 electrodes that are in the defined quadrants
erpData.quad <-subset(erpData.all, hemCode != 0)

#get factors without 0 and relabel
erpData.quad$hem <-factor(erpData.quad$hemCode)
levels(erpData.quad$hem)<-c("L","R")
erpData.quad$ant <-factor(erpData.quad$antCode)
levels(erpData.quad$ant)<-c("A","P")

#####Omnibus ANOVA######

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad,dv = .(amp),wid=.(subj),within=.(cond,hem,ant),type=3,detailed=TRUE)

#print results to file
print("All")
print(eztest)

#####Within Low Proportion ANOVA####

erpData.quad.lo <- subset(erpData.quad, prop == 'lo')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.lo,dv = .(amp),wid=.(subj),within=.(cond,hem,ant),type=3,detailed=TRUE)

#print results to file
print("Lo")
print(eztest)

#####Within High Proportion ANOVA####

erpData.quad.hi <- subset(erpData.quad, prop == 'hi')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.hi,dv = .(amp),wid=.(subj),within=.(cond,hem,ant),type=3,detailed=TRUE)

#print results to file
print("Hi")
print(eztest)


#####Within Anterior ANOVA####

erpData.quad.ant <- subset(erpData.quad, ant == 'A')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.ant,dv = .(amp),wid=.(subj),within=.(cond,hem),type=3,detailed=TRUE)

#print results to file
print("Ant")
print(eztest)

#####Within Posterior ANOVA####

erpData.quad.post <- subset(erpData.quad, ant == 'P')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.post,dv = .(amp),wid=.(subj),within=.(cond,hem),type=3,detailed=TRUE)

#print results to file
print("Post")
print(eztest)

#####Within Left ANOVA####

erpData.quad.left <- subset(erpData.quad, hem == 'L')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left,dv = .(amp),wid=.(subj),within=.(cond,ant),type=3,detailed=TRUE)

#print results to file
print("Left")
print(eztest)

#####Within Right ANOVA####

erpData.quad.right <- subset(erpData.quad, hem == 'R')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right,dv = .(amp),wid=.(subj),within=.(cond,ant),type=3,detailed=TRUE)

#print results to file
print("Right")
print(eztest)


#####Within Left, Within Anterior ANOVA####

erpData.quad.left.ant <- subset(erpData.quad, ant == 'A' & hem == 'L')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left.ant,dv = .(amp),wid=.(subj),within=.(cond),type=3,detailed=TRUE)

#print results to file
print("Left Ant")
print(eztest)

#####Within Left, Within Posterior ANOVA####

erpData.quad.left.post <- subset(erpData.quad, ant == 'P' & hem == 'L')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.left.post,dv = .(amp),wid=.(subj),within=.(cond),type=3,detailed=TRUE)

#print results to file
print("Left Post")
print(eztest)

#####Within Right, Within Anterior ANOVA####

erpData.quad.right.ant <- subset(erpData.quad, ant == 'A' & hem == 'R')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right.ant,dv = .(amp),wid=.(subj),within=.(cond),type=3,detailed=TRUE)

#print results to file
print("Right Ant")
print(eztest)

#####Within Right, Within Posterior ANOVA####

erpData.quad.right.post <- subset(erpData.quad, ant == 'P' & hem == 'R')

#compute the ANOVA
eztest <- ezANOVA(data=erpData.quad.right.post,dv = .(amp),wid=.(subj),within=.(cond),type=3,detailed=TRUE)

#print results to file
print("Right Post")
print(eztest)


########
#Print the marginal means
erpData.quad.aov <- aov(amp ~ cond * hem * ant + Error(subj/(cond * hem * ant)),data=erpData.quad)
print("Marginal Means")
print(model.tables(erpData.quad.aov,"means"),digits=5)
sink()

}