source_anova_Masked <-function(filePrefix,t1,t2){

library('ez')

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/source_space/R/"
load(paste(filePath,filePrefix,t1,"-",t2,".df",sep=""))
outfile <-paste(filePath,filePrefix,t1,"-",t2,"_anova_all.txt",sep="")
sink(outfile)

sourceData.all$prime<-factor(sourceData.all$cond,exclude=NULL)
levels(sourceData.all$prime)<-c("dir_rel","indir_rel","unrel")




eztest <-ezANOVA(data=sourceData.all,dv = .(amp),wid=.(subj),within=.(prime,roi,hemCode),type=3,detailed=TRUE)
print("1 x 3 relatedness")
print(eztest)


#####Condition 1 vs Condition 3####

sourceData.c1c3 <-subset(sourceData.all, prime != "indir_rel")

eztest <-ezANOVA(data=sourceData.c1c3,dv = .(amp),wid=.(subj),within=.(prime,roi,hemCode),type=3,detailed=TRUE)
print("c1c3")
print(eztest)


#####Print the marginal means
#sourceData.roi.aov <- aov(amp ~ prime  + Error(subj/(prime )),data=sourceData.roi)
#print("Marginal Means")
#print(model.tables(sourceData.roi.aov,"means"),digits=5)


sink()
}