#!/usr/bin/env python

import os
import sys
from glob import glob
import readInput
from readInput import readTable
import math
from pipeline import make_lingua

# studies = ['Baleen','MaskedMM','AXCPT']
# studies_codes = dict({'MaskedMM':['1','2','3','4','5'],'Baleen':['1','2','4','5','6','7','8','9','10','11','12']})
# studies_task = dict({'MaskedMM':['4','5'],'Baleen':['5','10','11','12']})
# studies_notask = dict({'MaskedMM':['1','2','3'],'Baleen':['1','2','4','6','7','8','9']})
# code_names = dict({'MaskedMM':['DirRel','IndRel','Unrel','InsPr','InsTar'],
# 					'Baleen':['LRelTar','LUnrTar','LUnrFil','LAnTar','HRelTar','HUnrTar','HRelFil',
# 								'HUnrFil','HAnTar','LAnPr','HAnPr'],
# 					'AXCPT':['AY','BY','BX','AX']})
##or "ac" in name or "sc" in name

codes = {"Baleen":{
			"1":("LP_RelTarg",False),
			"2":("LP_UnrTarg",False),
			"4":("LP_UnrFill",False),
			"5":("LP_AniTarg",True,0.0),
			"6":("HP_RelTarg",False),
			"7":("HP_UnrTarg",False),
			"8":("HP_RelFill",False),
			"9":("HP_UnrFill",False),
			"10":("HP_AniTarg",True,0.0),
			"11":("LP_AniPrime",True,0.6),
			"12":("HP_AniPrime",True,0.0)},
		"MaskedMM":{
			"1":("Directly",False),
			"2":("Indirectly",False),
			"3":("Unrelated",False),
			"4":("InsectPrime",True,0.1),
			"5":("InsctTarget",True,0)},
		"AXCPT":{
			"1":("A ------ Y",False),
			"2":("B ------ X",False),
			"3":("B ------ Y",False),
			"4":("A ------ X",True,0.0)}
		}

					
def find_eves(study,subject):
	all_eve =  glob(os.path.join('/cluster/kuperberg/SemPrMM/MEG/data',subject,'eve',"*"+study+'*Mod.eve'))
	return all_eve

	
def parse_eve(eve,study):
	lines = readTable(eve)
	results = dict()
	response_ind = [i for i,x in enumerate(lines) if x[3] == "16" or x[3] == "32" or x[3] == "64" or x[3] == "128"]
	for code in codes[study]:
		code_lines = [line for line in lines if line[3] == code]
		if len(code_lines) > 0: #code present at all
			cr = dict({})
			cr["c"] = 0
			cr["t"] = 0
			cr["rts"] = []
			for cl in code_lines:
				ct = float(cl[1])
				#using Mod.eve files, the task code always comes before the response
				after_response_ind = [i for i in response_ind if i > lines.index(cl)]
				if len(after_response_ind) > 0:
					rt = round(float(lines[after_response_ind[0]][1]) - ct,3)
				else:
					rt = -1
				task = codes[study][code][1]
				if study == "MaskedMM":
					good_rt = 0 < rt < 1.600
				elif study == "Baleen":
					good_rt = 0 < rt < 1.4
				elif study == "AXCPT":
					good_rt = 0< rt < 1.5
				if (task and good_rt) or (not task and not good_rt):
					cr["c"] += 1
					if task:
						cr["rts"].append(rt)
				cr["t"] += 1
			results[code] = cr
	if study == "AXCPT":
		for code in ["41","42","43","44"]:
			actual_code = code[1]
			num_misses = len([miss for miss in lines if miss[3] == code])
			results[actual_code]['t'] += num_misses
	return results


def parse_study(study,subjects):
	all_subjects = dict()
	for sub in subjects:
		sub_results = dict()
		eves = find_eves(study,sub)
		for eve in eves:
			results = parse_eve(eve,study)
			for key in results.keys():
				eve_results = results[key]
				if key in sub_results:
					sub_results[key]['t'] += eve_results['t']
					sub_results[key]['c'] += eve_results['c']
					sub_results[key]['rts'].extend(eve_results['rts'])
				else:
					sub_results[key] = eve_results
		all_subjects[sub] = sub_results
	return all_subjects

	
def get_subjects(study, subjType):
	path = os.path.join('/cluster/kuperberg/SemPrMM/','MEG/')
        if (subjType == 'ac'):
                subject_filename = path + 'scripts/function_inputs/ac.meg.all.txt'
        if (subjType == 'sc'):
                subject_filename = path + 'scripts/function_inputs/sc.meg.all.txt'
        if (subjType == 'ya'):
                subject_filename = path + 'scripts/function_inputs/ya.meg.all.txt'
        subject_list = readInput.readList(subject_filename)
        all_subs = []
        for row in subject_list:
                row = subjType+row
                all_subs.append(row)
                
	return [sub for sub in all_subs if len(find_eves(study,sub)) > 0]  
	

if __name__ == '__main__':

	subjType = sys.argv[1]
	study = sys.argv[2]
	print study
	subjects = sorted(get_subjects(study, subjType))
	print subjects
	study_results = parse_study(study,subjects)
	logf = '/cluster/kuperberg/SemPrMM/MEG/results/behavioral_accuracy/R/MEG_%s_%s_accuracy.log' % (subjType, study)
	with open(logf,'w') as f:
		f.write('sub:\t\t')
		good_keys = sorted([key for key in codes[study].keys()],lambda x,y:cmp(int(x),int(y)))
		#write out header
		f.write('CondCode\t\tAccuracy\tUnknown\n')
		for sub in sorted(study_results.keys()): 
			results = study_results[sub]
			total_num = 0
			total_den = 0
			for key in good_keys:
				v = results[key]
				total_num += v['c']
				total_den += v['t']
				if v['rts']:
					avg_rt = sum(v['rts']) / float(len(v['rts']))
				else:
					avg_rt = 0
				f.write(sub+':\t\t')
				f.write(codes[study][key][0]+'\t\t')
				f.write("%1.3f\t\t%1.3f\t\n" % (round(float(v['c'])/v['t'],3),round(avg_rt,3)))
			f.write('AllTasks\t')
			f.write("{0}\n".format(round(float(total_num)/total_den,3)))
		make_lingua(logf)

