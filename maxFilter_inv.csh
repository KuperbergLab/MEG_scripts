#!/bin/csh -f 


setenv SUBJECT $1
cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_MaxFilter

ln -s /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_projon/$1_BaleenHP_All-ave-7-meg-fwd.fif $1_BaleenHP_All-ave-7-meg-fwd.fif

mne_do_inverse_operator --fwd $1_BaleenHP_All-ave-7-meg-fwd.fif --depth --loose .4 --meg --senscov $1_Baleen_All-cov.fif --inv $1_BaleenHP_All-ave-7-meg-inv.fif

