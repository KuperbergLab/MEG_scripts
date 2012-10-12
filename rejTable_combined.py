#!/usr/bin/env python
"""rejTable_combined.py 
"""
#usage: python rejTable_combined.py subjType
#eg: python rejTable_combined.py ac

from os import path as op
import sys
from pipeline import load_data
import readInput

from writeOutput import writeTable
from pipeline import make_lingua
from mne import fiff

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
		subject_filename = data_path + 'scripts/function_inputs/sc.n16.meeg.b.txt'
    if (subjType == 'ya'):
		subject_filename = data_path + 'scripts/function_inputs/ya.meg.all.txt'
    subject_list = readInput.readList(subject_filename)
    subjects = []
    for row in subject_list:
    	row = subjType+row
    	subjects.append(row)
    
    all_data = get_data(subjects)
    
    ##make total table (total count of events presented in scanner that were answered correctly)
    for k,v in all_data.items():
      if k == 'BaleenHP': ##if we want to run a specific paradigm
        fname = '/%s/kuperberg/SemPrMM/MEG/results/artifact_rejection/combined_rejection/ssp/%s_%s_total_correct_events_ecgeog.txt' % (pre, subjType, k)
        codes = sorted(v[subjType+'8'].keys(), cmp=lambda x,y: cmp(int(x), int(y))) ##This is the codes for the events for the paradigm #using subj8 to get codes
        code_line = '\t\t%s' % '\t\t'.join(codes)   ##This just puts them together to head the table
        subject_lines = []
        for sub in subjects:
            if sub in v:
                if len(sub) > 3:  ##This makes the tabbing pretty for the table; different for longer subject names
                    beg = '%s\t' % sub
                else:
                    beg = '%s\t\t' % sub
                results = '\t\t'.join(['%i' % ( v[sub][code][1]) for code in codes])
                subject_lines.append('%s%s' % (beg, results))
        #write out dat for each paradigm
        f = open(fname, 'w')
        f.write(code_line + '\n')
        f.write('\n'.join(subject_lines))
        f.close()
        print("Saved total table to %s" % fname)
        make_lingua(fname)

	##make combined rejTable
    for k,v in all_data.items():
      if k == 'BaleenHP':
        fname = '/%s/kuperberg/SemPrMM/MEG/results/artifact_rejection/combined_rejection/ssp/%s_%s_remaining_events_ecgeog.txt' % (pre, subjType, k)
        codes = sorted(v[subjType+'8'].keys(), cmp=lambda x,y: cmp(int(x), int(y))) ##This is the codes for the events for the paradigm
        code_line = '\t\t%s' % '\t\t'.join(codes)   ##This just puts them together to head the table
        subject_lines = []
        for sub in subjects:
            subjLine = []
            if sub in v:
                if len(sub) > 3:  ##This makes the tabbing pretty for the table; different for longer subject names
                    beg = '%s\t' % sub
                else:
                    beg = '%s\t\t' % sub
            subjLine.append(beg)
            if k == 'ATLLoc':
            	aveName = '/%s/kuperberg/SemPrMM/MEG/data/%s/ave_projon/%s_%s-ave.fif' % (pre, sub, sub, k)
            else:
            	aveName = '/%s/kuperberg/SemPrMM/MEG/data/%s/ave_projon/%s_%s_All_ecgeog1-ave.fif' % (pre, sub, sub, k)
            count = 0
            results = beg
            for code in codes:
            	evoked=fiff.Evoked(aveName,setno=count)
            	count = count + 1
            	results = results + '\t\t' + str('%.2f' % (float(evoked.nave)/v[sub][code][1]))
            	print results
            subject_lines.append(results)
            print sub, subject_lines
        #write out dat for each paradigm
        f = open(fname, 'w')
        f.write(code_line + '\n')
        f.write('\n'.join(subject_lines))
        f.close()
        print("Saved combined table to %s" % fname)
        make_lingua(fname)
    pass
