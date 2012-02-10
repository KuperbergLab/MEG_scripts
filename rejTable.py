#!/usr/bin/env python

from os import path as op
import sys
from pipeline import load_data
import readInput

from writeOutput import writeTable
from pipeline import make_lingua

if sys.platform == 'darwin':
    pre = 'Volumes'
else:
    pre = 'cluster'

def get_data(subjects):
    all_data = {}
    for sub in subjects:
        eve_dat = op.join('/%s/kuperberg/SemPrMM/MEG/data/%s/eve' % (pre, sub), 'info.txt')
        try:
            dat = load_data(eve_dat)
            # reorient dat into all_dat
            for k,v in dat.items():
                if k not in all_data:
                    all_data[k] = {}
                all_data[k][sub] = v
        except IOError:
            pass
    return all_data

if __name__ == '__main__':
    data_path = '/cluster/kuperberg/SemPrMM/MEG/'
    subjType = sys.argv[1]
    if (subjType == 'ac'):
		subject_filename = data_path + 'scripts/function_inputs/ac.meg.all.txt'
    if (subjType == 'sc'):
		subject_filename = data_path + 'scripts/function_inputs/sc.meg.all.txt'
    if (subjType == 'ya'):
		subject_filename = data_path + 'scripts/function_inputs/ya.meg.all.possible.txt'
    subject_list = readInput.readList(subject_filename)
    subjects = []
    for row in subject_list:
    	row = subjType+row
    	subjects.append(row)
    print subjects
    
    all_data = get_data(subjects)
    for k,v in all_data.items():
        fname = '/%s/kuperberg/SemPrMM/MEG/results/artifact_rejection/heogveog_rejection/%s_%s_rejTable.txt' % (pre, subjType, k)
        codes = sorted(v[subjType+'3'].keys(), cmp=lambda x,y: cmp(int(x), int(y)))
        code_line = '\t\t%s' % '\t\t\t'.join(codes)
        subject_lines = []
        for sub in subjects:
            if sub in v:
                if len(sub) > 3:
                    beg = '%s\t' % sub
                else:
                    beg = '%s\t\t' % sub
                results = '\t\t'.join(['%.3f' % (float(v[sub][code][0]) / v[sub][code][1]) for code in codes])
                subject_lines.append('%s%s' % (beg, results))
        #write out dat for each paradigm
        f = open(fname, 'w')
        f.write(code_line + '\n')
        f.write('\n'.join(subject_lines))
        f.close()
        print("Saved rejection table to %s" % fname)
        make_lingua(fname)
    pass
