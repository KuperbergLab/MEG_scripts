import sys
import os
from glob import glob
import readInput
import writeOutput

def find_logs(exp,subj):
	all_logs =  glob(os.path.join('/cluster/kuperberg/SemPrMM/MEG/data',subj,'ave_projoff/logs',"*"+exp+'*-ave.log'))
	return all_logs

def get_subjects():
	path = os.path.join('/cluster/kuperberg/SemPrMM/','MEG','data')
	all_subs = [name for name in os.listdir(path) if "ya" in name and os.path.isdir(os.path.join(path, name))]
	return all_subs

def mneRejTable():
	
	expList = ['ATLLoc','MaskedMM','BaleenLP','BaleenHP','AXCPT']
	subjects = sorted(get_subjects())
	
	for subj in subjects:
		print subj,
		expCount = 0
		rejCount = [0, 0, 0, 0, 0]
		totalCount = [0, 0, 0, 0, 0]
	
		for exp in expList:
			#print exp
			
			all_logs = find_logs(exp,subj)
			#print all_logs
			
			for log in all_logs:
				if exp in log:
					#print log
					test = readInput.readTable(log)
					#print len(totalCount)
					totalCount[expCount] = totalCount[expCount] + len(test)
					
					for row in test:
						if len(row) > 8:
							#print len(row), row
							#print row[-8], row[3]
							
							rejCount[expCount] = rejCount[expCount] + 1
							
			expCount = expCount + 1
	
		#print rejCount
		#print totalCount
		for x in range(5):
			print int(round((float(rejCount[x])/float(totalCount[x]+1e-10))*100)),
		
		print 

if __name__ == "__main__":

	mneRejTable()