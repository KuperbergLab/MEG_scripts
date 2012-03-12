behav_stats_meg_Baleen <-function(subjType, listPrefix){

###This function outputs behavioral stats for the MEG session
###Currently focuses on the animal (go) trials only
	
filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/behavioral_accuracy/R/"
fileName <- paste(filePath,'MEG_',listPrefix,'_Baleen_accuracy.df',sep="")
load(fileName)

outFile <- paste(filePath,'MEG_',listPrefix,'_Baleen_acc_stats.txt',sep="")
sink(outFile)

##exclude subjects for whom there were errors in behavioral data recording
behavData.all = subset(behavData.all, subj != 'ya1')

##include only animal trials
behavData.animal<-behavData.all[behavData.all$cond == "LP_AniPrime" | behavData.all$cond == "LP_AniTarg" | behavData.all$cond == "HP_AniPrime" | behavData.all$cond == "HP_AniTarg", ]

###################################################
#################DESCRIPTIVE STATS#################

##Factorize data and print descriptive means
behavData.animal$prop<-factor(behavData.animal$cond,exclude=NULL);
levels(behavData.animal$prop)<-c("hi","hi","lo","lo");
behavData.animal$pos <-factor(behavData.animal$cond, exclude=NULL);
levels(behavData.animal$pos) <-c("prime","targ","prime","targ")

behavData.animal.aov = aov(acc ~ prop * pos + Error(subj/(prop * pos)),data=behavData.animal)

numSubj <-nlevels(factor(behavData.all$subj, exclude= NA))
print(paste("Table of Mean Accuracies, n:", numSubj,sep=" "))
print(model.tables(behavData.animal.aov, "means"), digits = 5)

##compute overall SD
LPHPprimetarg<-behavData.all[behavData.all$cond == "LP_AniPrime" | behavData.all$cond == "LP_AniTarg" | behavData.all$cond == "HP_AniPrime" | behavData.all$cond == "HP_AniTarg", ]
LPHPprimetargSD<-sd(LPHPprimetarg$acc)
print(paste("LPHPprimetargSD:",round(LPHPprimetargSD,3),sep=" "))

##################################################
##################ANOVAS##########################

library('ez')
eztest <-ezANOVA(data=behavData.animal,dv = .(acc),wid=.(subj),within=.(prop, pos),type=3,detailed=TRUE)
print(eztest)



sink()
}
