source_anova_roi_Baleen_fillers <-function(filePrefix,t1,t2,testroi,testhem){

library('ez')

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/source_space/R/"
load(paste(filePath,filePrefix,t1,"-",t2,".df",sep=""))
outfile <-paste(filePath,filePrefix,t1,"-",t2,"_anova_fillers_",testroi,"-",testhem,".txt",sep="")
sink(outfile)

sourceData.all$prime<-factor(sourceData.all$cond,exclude=NULL)
levels(sourceData.all$prime)<-c("rel","unrel")

sourceData.roi <- subset(sourceData.all,roi==testroi & hemCode==testhem)

eztest <-ezANOVA(data=sourceData.roi,dv = .(amp),wid=.(subj),within=.(prime),type=3,detailed=TRUE)
print(eztest)


#####Print the marginal means
sourceData.roi.aov <- aov(amp ~ prime + Error(subj/(prime)),data=sourceData.roi)
print("Marginal Means")
print(model.tables(sourceData.roi.aov,"means"),digits=5)


sink()
}