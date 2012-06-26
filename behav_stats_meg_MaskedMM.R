behav_stats_meg_MaskedMM <-function(listPrefix){

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
behavData.insect<-behavData.all[behavData.all$cond == "InsectPrime" | behavData.all$cond == "InsectTarget", ] 


###################################################
#################DESCRIPTIVE STATS#################

behavData.insect$pos <-factor(behavData.insect$cond, exclude=NULL);
levels(behavData.insect$pos) <-c("prime","targ")

behavData.insect.aov = aov(acc ~ pos,data=behavData.insect)

numSubj <-nlevels(factor(behavData.all$subj, exclude= NA))
print(paste("Table of Mean Accuracies, n:", numSubj,sep=" "))
print(model.tables(behavData.insect.aov, "means"), digits = 5)


##compute overall SD
print("")
print(paste("InsectprimetargSD:",round(sd(behavData.insect$acc),3), sep=" "))

#######################################################
##Factorize data and print descriptive means


##################################################
##################ANOVAS##########################

library('ez')
eztest <-ezANOVA(data=behavData.insect,dv = .(acc),wid=.(subj),within=.(pos),type=3,detailed=TRUE)
print(eztest)

sink()
}
