
codes = {'BaleenHP':('6', '7', '8', '9', '10', '12','14','18'),
         'BaleenLP':('1', '2', '4', '5', '11','14'),
         'MaskedMM':('1', '2', '3', '4', '5'),
         'ATLLoc':('41', '42', '43','1','2','3'),
         'AXCPT':('1', '2', '3', '4','5','6'),
         'AXCPTtar':('1', '2', '3', '4'),
         'AXCPTpri':('4', '5')}
         
condLabels = {'Blink': 
        	[['1','Blink']],
		'ATLLoc':
			[['41','Sentences'],
			['42','WordLists'],
			['43','ConsonantStrings'],
			['1','SentenceFirstWord'],
			['2','WordListFirstWord'],
			['3','ConsonantStringFirstWord']],
		'MaskedMM': 			
			[['1','Direct'],
			['2','Indirect'],
			['3','Unrelated'],
			['4','ProbePrime'],
			['5','ProbeTarget']],
		'BaleenLP':
			[['1','Related'],
			['2','Unrelated'],
			['4','UnrelatedFiller'],
			['5','ProbeTarget'],
			['11','ProbePrime'],
			['14','Prime']],
		'BaleenHP': 
			[['6','Related'],
			['7','Unrelated'],
			['8','RelatedFiller'],
			['9','UnrelatedFiller'],
			['10','ProbeTarget'],
			['12','ProbePrime'],
			['14', 'Prime'],
			['18','RelatedFillerExtra']],
		'AXCPT':
			[['1','AYtarget'],
			['2','BXtarget'],
			['3','BYtarget'],
			['4','AXtarget'],
			['5','Aprime'],
			['6','Bprime']],
                'AXCPTtar':
			[['1','AYtarget'],
			['2','BXtarget'],
			['3','BYtarget'],
			['4','AXtarget']],
                'AXCPTpri':
			[['5','Aprime'],
			['6','Bprime']]
			}

runDict = {'Blink':[''],'ATLLoc':[''],'MaskedMM':['Run1','Run2'],'BaleenLP':['Run1','Run2','Run3','Run4'],'BaleenHP':['Run1','Run2','Run3','Run4'],'AXCPT':['Run1','Run2'], 'AXCPTtar':['Run1','Run2'], 'AXCPTpri':['Run1','Run2']}

         
##Notice the epochs are coded in samples, not ms : (
epochs = {}
for exp in codes:
	count = 0
	temp = {}
	for code in codes[exp]:
		if exp == 'ATLLoc':
			temp[codes[exp][count]] = [60,300]
		elif exp == 'MaskedMM':
			temp[codes[exp][count]] = [60,421]
		else:
			temp[codes[exp][count]] = [60,421]
		count = count + 1
	epochs[exp] = temp

	
epMax = {'Blink':'.9',
	'ATLLoc':'.5',
	'MaskedMM':'.7',
	'BaleenLP':'.7',
	'BaleenHP':'.7',
	'AXCPT':'.7',
        'AXCPTtar':'.7',
        'AXCPTpri':'.7'}
