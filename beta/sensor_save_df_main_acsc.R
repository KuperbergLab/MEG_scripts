sensor_save_df_main_acsc <-function(filePrefix,exp,t1,t2){
	
filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
fileName <- paste(filePath,'acsc_',filePrefix,exp,'.',t1,"-",t2,".txt",sep="")
buffer<-read.table(fileName)
erpData.all<-data.frame(sgroup=factor(buffer$V1),subj=factor(buffer$V2),cond=factor(buffer$V3),elec=factor(buffer$V4),amp=buffer$V5,hemCode=factor(buffer$V6),antCode=factor(buffer$V7),midV=factor(buffer$V8),midH=factor(buffer$V9),elec9=(buffer$V10))

outFile <- paste(filePath,'acsc_',filePrefix,exp,'.',t1,"-",t2,".df",sep="")
save(erpData.all,file=outFile)
}
