behav_stats_meg <-function(subjType,exp){
	
filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/behavioral_accuracy/R/"
fileName <- paste(filePath,'MEG_',subjType,'_',exp,"_accuracy.df",sep="")
load(fileName)

behavData.all = subset(behavData.all, subj != 'ya1')

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
LPHPprimetargSD<-sd(LPHPprimetarg$acc)
 

numSubj <-nlevels(factor(behavData.all$subj, exclude= NA))

outFile <- paste(filePath,'MEG_',subjType,'_',exp,"_acc_stats.txt",sep="")
sink(outFile)
print(paste("Table of Mean Accuracies, n:", numSubj,sep=" "))
print(c("LPprimeMean",round(LPprimeMean,3)))
print(c("HPprimeMean",round(HPprimeMean,3)))
print(c("LPtargMean",round(LPtargMean,3)))
print(c("HPtargMean",round(HPtargMean,3)))

print("Table of Mean Accuracies for LP and HP")
print(c("LPprimetargMean",round(LPprimetargMean,3)))
print(c("HPprimetargMean",round(HPprimetargMean,4)))

print(paste("LPHPprimetargMean:",round(LPHPprimetargMean,3),"   SD:",round(LPHPprimetargSD,3),sep=" "))

sink()
}
