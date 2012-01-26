#!/usr/bin/env python

# python rej2eve.py ya17

import sys
from glob import glob
from os import path as op

from readInput import readTable
from writeOutput import writeTable

import condCodes as cc

sub = sys.argv[1]

pre = '/cluster/kuperberg/SemPrMM/MEG/data'
data_d = '%s/%s/' % (pre,sub)
temp_d = '%s/%s/rej/' % (pre, sub)
eve_dir = '%s/%s/eve/' % (pre, sub)
                      
epochs = cc.epochs                      

type_rep = {'veog':'1000',
            'heog':'2000',
            'eeg':'3000'
            }

def samp2dict(gen, r):
    """
    return a dictionary of code:range
    """
    new_samp = {}
    for s in gen:
        new_samp[s] = range(s-r[0],s+r[1])
    return new_samp

def reject(type, d, eve_data, rej_data):
#    print('Rejection type: %s' % type)
    # for each code we're worrying about
    to_return = {}
    for c,r in d.items():
        gen = [int(e[0]) for e in eve_data if e[3] == c]
        # samp_dict holds an key for every sample in which a code of interest occured
        # it's value is a range of integers during which we "care" about the event
        samp_dict = samp2dict(gen, r)
        # set of rejection samples
        rej_set = set((int(r[0]) for r in rej_data))
        bad_samp = []
        for samp, ra in samp_dict.items():
            #find intersection
            if len(set(ra).intersection(rej_set)) > 0:
                bad_samp.append(samp)
        #recode events that intersect
#        print('code:%s\t\t%d colisions \t(%d total)' % (c, len(bad_samp), len(samp_dict.keys())))
        to_return[c] = bad_samp
    return to_return
    
def new_eve(eve):
    print 'Starting with %s' % eve
    eve_d = readTable(eve)
    rej_types = ('veog', 'heog') # , 'grad', 'mag', 'eeg'
    k = filter(lambda y: y in eve, epochs.keys())[0]
    new_eve = eve_d[:]
    for type in rej_types:
        #get type from all_rej
        bname = op.basename(eve)
        base, _, _ = bname.rpartition('Mod.eve')
        search = op.join(temp_d, '%s_raw_%s.txt' % (base,type))
        rej = glob(search)
        if len(rej) < 1:
            raise Exception('No rej of this type found!')
        bad_dict = reject(type, epochs[k], new_eve, readTable(rej[0]))
        for code, r in bad_dict.items():
            f = lambda x:[x[0], x[1], x[2], str(int(type_rep[type])+int(code))] if x[3] == code and int(x[0]) in r else x
            new_eve[:] = map(f, new_eve)
        pass
    new_fname = op.join(eve_dir, '%s%s.eve' % (op.basename(eve).rpartition('.eve')[0], 'Rej'))
    print("Writing new eve to %s" % new_fname)
    writeTable(new_fname, new_eve)
    
if __name__ == '__main__':

    for eve in glob(op.join(eve_dir,'*Mod.eve')):
       if ('BlinkMod.eve' not in eve):
####       eve != glob(op.join(eve_dir, '*BlinkMod.eve'))):
            print(eve)
            new_eve(eve)
        
            
            
        
