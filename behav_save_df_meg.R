behav_save_df_meg <-function(subjType,exp){
	
filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/behavioral_accuracy/R/"
fileName <- paste(filePath,'MEG_',subjType,'_',exp,"_accuracy.log",sep="")
buffer<-read.table(fileName)
behavData.all<-data.frame(subj=factor(buffer$V1),cond=factor(buffer$V2),acc=buffer$V3,rt=buffer$V4)



LPprime<-behavData.all[behavData.all$cond == "LP_AniPrime", ]
LPtarg <-behavData.all[behavData.all$cond == "LP_AniTarg", ]
HPprime<-behavData.all[behavData.all$cond == "HP_AniPrime", ]
HPtarg <-behavData.all[behavData.all$cond == "HP_AniTarg", ]

LPprimeMean<-mean(LPprime$acc)
LPtargMean<-mean(LPtarg$acc)
HPprimeMean<-mean(HPprime$acc)
HPtargMean<-mean(HPtarg$acc)

LPprimetarg<-behavData.all[behavData.all$cond == "LP_AniPrime" | behavData.all$cond == "LP_AniTarg", ]
HPprimetarg<-behavData.all[behavData.all$cond == "HP_AniPrime" | behavData.all$cond == "HP_AniTarg", ]

LPprimetargMean<-mean(LPprimetarg$acc)
HPprimetargMean<-mean(HPprimetarg$acc)

LPHPprimetarg<-behavData.all[behavData.all$cond == "LP_AniPrime" | behavData.all$cond == "LP_AniTarg" | behavData.all$cond == "HP_AniPrime" | behavData.all$cond == "HP_AniTarg", ]

LPHPprimetargMean<-mean(LPHPprimetarg$acc)

outFile2 <- paste(filePath,'MEG_',subjType,'_',exp,".txt",sep="")
sink(outFile2)
print("Table of Mean Accuracies")
print("LPprimeMean")
print(LPprimeMean)
print("HPprimeMean")
print(HPprimeMean)
print("LPtargMean")
print(LPtargMean)
print("HPtargMean")
print(HPtargMean)

print("Table of Mean Accuracies for LP and HP")
print("LPprimetargMean")
print(LPprimetargMean)
print("HPprimetargMean")
print(HPprimetargMean)

print("LPHPprimetargMean")
print(LPHPprimetargMean)

sink()
}