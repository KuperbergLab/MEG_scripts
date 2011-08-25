#!/bin/csh
#usage extractROItime.sh subjID label

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 1 ) then 
    echo "NO LABEL ARGUMENT"
    exit 1
endif

setenv SUBJECT $1
cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_projon

mkdir label
mkdir label_timecourses

cd label

mne_annot2labels --subject $1 --parc aparc.a2009s

cd ../

mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --smooth 7 --spm --label label/$2-lh.label --labeloutdir label_timecourses

mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --smooth 7 --spm --label label/$2-rh.label --labeloutdir label_timecourses
