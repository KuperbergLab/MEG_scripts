sensor_save_df_main <-function(filePrefix,exp,chanGroupName,t1,t2){
	
filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/R/"
fileName <- paste(filePath,filePrefix,".",exp,".",chanGroupName,".",t1,"-",t2,".txt",sep="")
buffer<-read.table(fileName)
#print(buffer)

####Specific code for each channel grouping
if(chanGroupName == 'quad48Mid'){
erpData.all<-data.frame(subj=factor(buffer$V6),subjGroup=factor(buffer$V5),exp=factor(buffer$V7),cond=factor(buffer$V8),elec=factor(buffer$V4),hemCode=factor(buffer$V1),antCode=factor(buffer$V2),chanLabel=factor(buffer$V3),amp=buffer$V9)
}

if(chanGroupName == 'gk_peripheral'){
erpData.all<-data.frame(subj=factor(buffer$V6),sGroup=factor(buffer$V5),exp=factor(buffer$V7),cond=factor(buffer$V8),elec=factor(buffer$V4),hem=factor(buffer$V1),APDist=factor(buffer$V2),chanLabel=factor(buffer$V3),amp=buffer$V9)
}

if(chanGroupName == 'gk_midline'){
erpData.all<-data.frame(subj=factor(buffer$V5),sGroup=factor(buffer$V4),exp=factor(buffer$V6),cond=factor(buffer$V7),elec=factor(buffer$V3),APDist=factor(buffer$V1),chanLabel=factor(buffer$V2),amp=buffer$V8)
}

if(chanGroupName == 'elec_9'){
erpData.all<-data.frame(subj=factor(buffer$V5),sGroup=factor(buffer$V4),exp=factor(buffer$V6),cond=factor(buffer$V7),elec=factor(buffer$V3),chanLabel=factor(buffer$V2),amp=buffer$V8)
}

if(chanGroupName == 'centropar_15'){
erpData.all<-data.frame(subj=factor(buffer$V5),sGroup=factor(buffer$V4),exp=factor(buffer$V6),cond=factor(buffer$V7),elec=factor(buffer$V3),chanLabel=factor(buffer$V2),amp=buffer$V8)
}


outFile <- paste(filePath,filePrefix,".",exp,".",chanGroupName,".",t1,"-",t2,".df",sep="")
save(erpData.all,file=outFile)
}
