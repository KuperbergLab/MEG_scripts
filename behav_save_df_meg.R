behav_save_df_meg <-function(subjType,exp){
	
filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/behavioral_accuracy/R/"
fileName <- paste(filePath,'MEG_',subjType,'_',exp,"_accuracy.log",sep="")
buffer<-read.table(fileName)
behavData.all<-data.frame(subj=factor(buffer$V1),cond=factor(buffer$V2),acc=buffer$V3,rt=buffer$V4)

outFile <- paste(filePath,'MEG_',subjType,'_',exp,".df",sep="")
save(behavData.all,file=outFile)
}