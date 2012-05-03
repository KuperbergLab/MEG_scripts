#!/usr/bin/env python
"""Compute the number of ecg and eog events in the input raw.fif files

You can do for example:

$ecgeogTable.py -i sample_audvis_raw.fif -c "MEG 1531" --l-freq 1 --h-freq 100 --rej-grad 3000 --rej-mag 4000 --rej-eeg 100
"""
#Author: CandidaUstine

import sys
import os
import mne
from mne import fiff
sys.path.insert(0,'/cluster/kuperberg/SemPrMM/MEG/mne-python/')

def ecgeogTable(in_fif_fname, par, subjID, out_text_file, ch_name):
    
    #in_fif_fname = in_path + in_fif_fname
    # Reading fif File
    raw = mne.fiff.Raw(in_fif_fname, preload='tmp.mmap')
        
#######################################################################################################################
    print 'Counting the average pulse rate and the average eog per run in each paradigm'
    ecg_events, _, average_pulse = mne.artifacts.find_ecg_events(raw, ch_name=ch_name)
    average_pulse = round(average_pulse, 4)
    print average_pulse
    eog_events = mne.artifacts.find_eog_events(raw) 
    print len(eog_events)

    parName = str(par)
    name1=str.split(str(in_fif_fname), '_raw.fif')
    name2=str.split(str(name1[0]), str(subjID))
    name3=str.split(str(name2[1]), '_')
    
    myFile2 = open(out_text_file, "a") 
    myFile2.write("\n")
    myFile2.write(str(name3[1]))
    myFile2.write("\t")
    myFile2.write(str(average_pulse))
    myFile2.write("\t")
    myFile2.write(str(len(eog_events)))   

    
###################################################################################################    

if __name__ == '__main__':

    raw_in = sys.argv[1]
    par = sys.argv[2]
    subjID = sys.argv[3]
    txt_out = sys.argv[4]
    ch_name = sys.argv[5]
    ecgeogTable(raw_in, par, subjID, txt_out, ch_name)

###################################################################################################

