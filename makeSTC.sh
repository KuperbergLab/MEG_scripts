#!/bin/csh

setenv SUBJECT $1
cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_projon

mkdir stc

#####Make stc files to subtract in Matlab####

###Unmorphed##

##This is set 3, the unrelated filler in LP
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 3 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c3-spm.stc --smooth 5 --spm

##This is sets 1 and 2, targets of interest in LP
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c1-spm.stc --smooth 5 --spm
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c2-spm.stc --smooth 5 --spm

##This is sets 1 and 2, targets of interest in HP
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c1-spm.stc --smooth 5 --spm
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c2-spm.stc --smooth 5 --spm


##Morphed##

###dspm####

##This is set 3, the unrelated filler in LP
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 3 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c3M-spm.stc --smooth 5 --spm --morph fsaverage

##This is sets 1 and 2, targets of interest in LP
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c1M-spm.stc --smooth 5 --spm --morph fsaverage
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c2M-spm.stc --smooth 5 --spm --morph fsaverage

##This is sets 1 and 2, targets of interest in HP
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c1M-spm.stc --smooth 5 --spm --morph fsaverage
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c2M-spm.stc --smooth 5 --spm --morph fsaverage

###MNE####
##This is set 3, the unrelated filler in LP
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 3 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c3M-mne.stc --smooth 5 --morph fsaverage

########FIX GROUP ON ALL FILES########
chgrp -R lingua .

