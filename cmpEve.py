#!/usr/bin/env python

# python rej2eve.py ya17

import sys
from glob import glob
from os import path as op

from pipeline import save_data

from readInput import readTable
from writeOutput import writeTable

import condCodes as cc

sub = sys.argv[1]

pre = '/cluster/kuperberg/SemPrMM/MEG/data'
data_d = '%s/%s/' % (pre,sub)
eve_dir = '%s/%s/eve/' % (pre, sub)


def compare(efile, rfile):
    print 'Starting comparison on %s and %s' % (efile, rfile)
    study = filter(lambda x: x in efile and x in rfile, cc.codes.keys())[0]
    eve = readTable(efile)
    rej = readTable(rfile)
    d = {}
    for code in cc.codes[study]:
        neve = len([e for e in eve if e[3] == code])
        nrej = len([r for r in rej if r[3] == code])
#        print('Code %s\tEve# %d\t Rej# %d' % (code, neve, nrej))
        d[code] = [nrej, neve]
    return study, d

if __name__ == '__main__':
    rej = glob(op.join(eve_dir, '*Rej.eve'))
    eve = glob(op.join(eve_dir, '*Mod.eve'))
    rej.sort()
    eve.sort()
    data = {}
    for e, r in zip(eve, rej):
        par, d = compare(e, r)
        if par in data:
            for code in d:
                data[par][code] = [d[code][0] + data[par][code][0], d[code][1] + data[par][code][1]]
        else:
            data[par] = d
    dat_file = op.join(eve_dir, 'info.txt')
    print('Saving data to %s' % dat_file)
    save_data(data, dat_file)