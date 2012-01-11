#!/bin/csh -f 

#usage makeSTC.sh subjID logfile

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 1 ) then
    set log='./makeSTCAllUnrelated.log'
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



#####Make stc files to subtract in Matlab####


# Morphed##
# 
# #dspm####
# 

###############BALEEN#######################
# This is set 1, the unrelated targets in LP

mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-inv.fif --meas $1_BaleenLP_AllUnrelated-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenLP_AllUnrelated_c1M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log
 
###############BALEEN#######################
# This is set 1, the unrelated targets in HP

mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_AllUnrelated-ave.fif --set 1 --bmin -100 --bmax -.01 --stc stc/$1_BaleenHP_AllUnrelated_c1M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log



########FIX GROUP ON ALL FILES########
chgrp -R lingua .

