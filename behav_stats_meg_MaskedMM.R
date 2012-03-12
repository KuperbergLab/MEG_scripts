behav_stats_meg_MaskedMM <-function(subjType, listPrefix){

###This function outputs behavioral stats for the MEG session
###Currently focuses on the animal (go) trials only
	
filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/behavioral_accuracy/R/"
fileName <- paste(filePath,'MEG_',listPrefix,'_MaskedMM_accuracy.df',sep="")
load(fileName)

outFile <- paste(filePath,'MEG_',listPrefix,'_MaskedMM_acc_stats.txt',sep="")
sink(outFile)

##exclude subjects for whom there were errors in behavioral data recording
##behavData.all = subset(behavData.all, subj != 'ya1')

##include only animal trials
behavData.maskedmm<-behavData.all[behavData.all$cond == "InsectPrime" | behavData.all$cond == "InsctTarget", ] 


###################################################
#################DESCRIPTIVE STATS#################
Instar<-behavData.maskedmm[behavData.maskedmm$cond == "InsctTarget", ]
print(paste("InsectTarget_MeanAccuracy:", round(mean(Instar$acc),5), sep=" "))

Insprime<-behavData.maskedmm[behavData.maskedmm$cond == "InsectPrime", ]
print(paste("InsectPrime_MeanAccuracy:", round(mean(Insprime$acc),5), sep=" "))

##compute overall Mean Accuracy
print(paste("InsectTargetPrime_MeanAccuracy:", round(mean(behavData.maskedmm$acc),5), sep=" "))

##compute overall SD
print(paste("InsectprimetargSD:",round(sd(behavData.maskedmm$acc),3), sep=" "))

#######################################################
##Factorize data and print descriptive means
##behavData.maskedmm$pos <-factor(behavData.maskedmm$cond, exclude=NULL);
##levels(behavData.maskedmm$pos) <-c("prime","targ")

##behavData.maskedmm.aov = aov(acc ~ pos,data=behavData.maskedmm)

##numSubj <-nlevels(factor(behavData.all$subj, exclude= NA))
##print(paste("Table of Mean Accuracies, n:", numSubj,sep=" "))
##print(model.tables(behavData.maskedmm.aov, "means"), digits = 5)

##################################################
##################ANOVAS##########################

##library('ez')
##eztest <-ezANOVA(data=behavData.maskedmm,dv = .(acc),wid=.(subj),within=.(prop, pos),type=3,detailed=TRUE)
##print(eztest)



sink()
}
