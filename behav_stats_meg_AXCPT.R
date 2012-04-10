behav_stats_meg_AXCPT <-function(listPrefix){

###This function outputs behavioral stats for the MEG session
	
filePath <- "/cluster/kuperberg/SemPrMM/MEG/results/behavioral_accuracy/R/"
fileName <- paste(filePath,'MEG_',listPrefix,'_AXCPT_accuracy.df',sep="")
load(fileName)

outFile <- paste(filePath,'MEG_',listPrefix,'_AXCPT_acc_stats.txt',sep="")
sink(outFile)

##exclude subjects for whom there were errors in behavioral data recording
##behavData.all = subset(behavData.all, subj != 'ya1')


###################################################
#################DESCRIPTIVE STATS#################

behavData.all.aov = aov(acc ~ cond,data=behavData.all)

numSubj <-nlevels(factor(behavData.all$subj, exclude= NA))
print(paste("Table of Mean Accuracies, n:", numSubj,sep=" "))
print(model.tables(behavData.all.aov, "means"), digits = 5)


##################################################
##################ANOVAS##########################
library('ez')

####COMPARE BX and BY#####
behavData.bxby = subset(behavData.all, cond == 'BX' | cond == 'BY')
eztest <-ezANOVA(data=behavData.bxby,dv = .(acc),wid=.(subj),within=.(cond),type=3,detailed=TRUE)
print("Paired comparison BX vs BY")
print(eztest)

####COMPARE BX and BY#####
behavData.ayby = subset(behavData.all, cond == 'AY' | cond == 'BY')
eztest <-ezANOVA(data=behavData.ayby,dv = .(acc),wid=.(subj),within=.(cond),type=3,detailed=TRUE)
print("Paired comparison AY vs BY")
print(eztest)

sink()
}
