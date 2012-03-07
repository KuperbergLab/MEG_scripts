
codes = {'BaleenHP':('6', '7', '8', '9', '10', '12','14','18'),
         'BaleenLP':('1', '2', '4', '5', '11','14'),
         'MaskedMM':('1', '2', '3', '4', '5'),
         'ATLLoc':('41', '42', '43','1','2','3'),
         'AXCPT':('1', '2', '3', '4','5','6')}
         
condLabels = {'Blink': 
        	[['1','Blink']],
		'ATLLoc':
			[['41','Sentences'],
			['42','Word Lists'],
			['43','Consonant Strings'],
			['1','Sentence First Word'],
			['2','Word List First Word'],
			['3','Consonant String First Word']],
		'MaskedMM': 			
			[['1','Direct'],
			['2','Indirect'],
			['3','Unrelated'],
			['4','Probe Target'],
			['5','Probe Prime']],
		'BaleenLP':
			[['1','Related'],
			['2','Unrelated'],
			['4','Unrelated Filler'],
			['5','Probe Target'],
			['11','Probe Prime'],
			['14','Prime']],
		'BaleenHP': 
			[['6','Related'],
			['7','Unrelated'],
			['8','Related Filler'],
			['9','Unrelated Filler'],
			['10','Probe Target'],
			['12','Probe Prime'],
			['14', 'Prime'],
			['18','Related Filler Extra']],
		'AXCPT':
			[['1','AY target'],
			['2','BX target'],
			['3','BY target'],
			['4','AX target'],
			['5','A prime'],
			['6','B prime']]
			}

         
##Notice the epochs are coded in samples, not ms : (
epochs = {}
for exp in codes:
	count = 0
	temp = {}
	for code in codes[exp]:
		if exp == 'ATLLoc':
			temp[codes[exp][count]] = [60,300]
		elif exp == 'MaskedMM':
			temp[codes[exp][count]] = [60,360]
		else:
			temp[codes[exp][count]] = [60,421]
		count = count + 1
	epochs[exp] = temp

	
epMax = {'Blink':'.9',
	'ATLLoc':'.5',
	'MaskedMM':'.6',
	'BaleenLP':'.7',
	'BaleenHP':'.7',
	'AXCPT':'.7'}
