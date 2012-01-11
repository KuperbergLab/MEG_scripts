source_anova_roi_Baleen <-function(filePrefix,t1,t2,testroi,testhem){

library('ez')

filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/source_space/R/"
load(paste(filePath,filePrefix,t1,"-",t2,".df",sep=""))
outfile <-paste(filePath,filePrefix,t1,"-",t2,"_anova_",testroi,"-",testhem,".txt",sep="")
sink(outfile);

sourceData.all$prime<-factor(sourceData.all$cond,exclude=NULL);
levels(sourceData.all$prime)<-c("rel","unrel","rel","unrel");
sourceData.all$prop<-factor(sourceData.all$cond,exclude=NULL);
levels(sourceData.all$prop)<-c("hi","hi","lo","lo");

sourceData.roi <- subset(sourceData.all,roi==testroi & hemCode==testhem)

eztest <-ezANOVA(data=sourceData.roi,dv = .(amp),wid=.(subj),within=.(prime,prop),type=3,detailed=TRUE)

print(eztest)

#

sink()

}