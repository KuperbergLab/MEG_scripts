#!/bin/csh
#usage makeSTC.sh subjID logfile

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 1 ) then
    set log='./makeSTC.log'
    echo "Logging to default log..." >>& $log
endif

if ( $#argv == 2) then
    set log=$2
endif

# if log exists, delete
if ( -e $log ) then
    rm $log
endif


setenv SUBJECT $1
cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_projon

mkdir stc

#####Make stc files to subtract in Matlab####

###Unmorphed##

##This is set 3, the unrelated filler in LP
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 3 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c3-spm.stc --smooth 7 --spm >>& $log

##This is sets 1 and 2, targets of interest in LP
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c1-spm.stc --smooth 7 --spm >>& $log
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c2-spm.stc --smooth 7 --spm >>& $log

##This is sets 1 and 2, targets of interest in HP
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c1-spm.stc --smooth 7 --spm >>& $log
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c2-spm.stc --smooth 7 --spm >>& $log


##Morphed##

###dspm####

###############ATLLOC#######################
mne_make_movie --inv $1_ATLLoc-ave-7-meg-inv.fif --meas $1_ATLLoc-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_ATLLoc_c1M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

mne_make_movie --inv $1_ATLLoc-ave-7-meg-inv.fif --meas $1_ATLLoc-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_ATLLoc_c2M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

mne_make_movie --inv $1_ATLLoc-ave-7-meg-inv.fif --meas $1_ATLLoc-ave.fif --set 3 --bmin -100 --bmax -.01 --stc stc/$1_ATLLoc_c3M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

###############MASKEDMM#####################
mne_make_movie --inv $1_MaskedMM_All-ave-7-meg-inv.fif --meas $1_MaskedMM_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_MaskedMM_All_c1M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

mne_make_movie --inv $1_MaskedMM_All-ave-7-meg-inv.fif --meas $1_MaskedMM_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_MaskedMM_All_c2M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

mne_make_movie --inv $1_MaskedMM_All-ave-7-meg-inv.fif --meas $1_MaskedMM_All-ave.fif --set 3 --bmin -100 --bmax -.01 --stc stc/$1_MaskedMM_All_c3M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

###############BALEEN#######################
##This is set 3, the unrelated filler in LP
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 3 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c3M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

##This is sets 1 and 2, targets of interest in LP
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c1M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c2M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

##This is sets 1 and 2, targets of interest in HP
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c1M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c2M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

##This is sets 3 and 4, related (half) and unrelated fillers in HP
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 3 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c3M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 4 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c4M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

###############AXCPT#######################
mne_make_movie --inv $1_AXCPT_All-ave-7-meg-inv.fif --meas $1_AXCPT_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_AXCPT_All_c1M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

mne_make_movie --inv $1_AXCPT_All-ave-7-meg-inv.fif --meas $1_AXCPT_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_AXCPT_All_c2M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

mne_make_movie --inv $1_AXCPT_All-ave-7-meg-inv.fif --meas $1_AXCPT_All-ave.fif --set 3 --bmin -100 --bmax -.01 --stc stc/$1_AXCPT_All_c3M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log


#######################################################################

###MNE####
##This is set 3, the unrelated filler in LP
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 3 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c3M-mne.stc --smooth 7 --morph fsaverage >>& $log

##This is sets 1 and 2, targets of interest in LP
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c1M-mne.stc --smooth 7 --morph fsaverage >>& $log
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_All_c2M-mne.stc --smooth 7 --morph fsaverage >>& $log

##This is sets 1 and 2, targets of interest in HP
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c1M-mne.stc --smooth 7 --morph fsaverage >>& $log
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c2M-mne.stc --smooth 7 --morph fsaverage >>& $log

##This is sets 3 and 4, related and unrelated fillers in HP
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 3 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c3M-mne.stc --smooth 7 --morph fsaverage >>& $log
mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 4 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_All_c4M-mne.stc --smooth 7 --morph fsaverage >>& $log

########FIX GROUP ON ALL FILES########
chgrp -R lingua .

