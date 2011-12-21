save_df_main <-function(filePrefix,t1,t2){
	
filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
fileName <- paste(filePath,filePrefix,t1,"-",t2,".txt",sep="")
buffer<-read.table(fileName)
erpData.all<-data.frame(subj=factor(buffer$V1),cond=factor(buffer$V2),elec=factor(buffer$V3),amp=buffer$V4,hemCode=factor(buffer$V5),antCode=factor(buffer$V6),midV=factor(buffer$V7),midH=factor(buffer$V8))

erpData.all$prime<-factor(erpData.all$cond,exclude=NULL);
levels(erpData.all$prime)<-c("rel","unrel","rel","unrel");
erpData.all$prop<-factor(erpData.all$cond,exclude=NULL);
levels(erpData.all$prop)<-c("lo","lo","hi","hi");

outFile <- paste(filePath,filePrefix,t1,"-",t2,".df",sep="")
save(erpData.all,file=outFile)
}