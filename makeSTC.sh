#!/bin/csh -f

#usage makeSTC.sh subjID logfile
#you need to change the exp variable and condList below to run STCs for your experiment of interest

set exp = "BaleenLP_All"
echo $exp

set condList = (1 2)
echo $condList

####################################

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

###################################

setenv SUBJECT $1
cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_projon

mkdir stc
mkdir stc/$exp

foreach c ($condList)

	echo Unmorphed mne >>& $log
	mne_make_movie --inv $1_$exp-ave-7-meg-inv.fif --meas $1_{$exp}-ave.fif --set $c --bmin -100 --bmax -.01 --stc stc/$exp/$1_{$exp}_c{$c}-mne.stc --smooth 7 >>& $log
	
	echo Unmorphed spm >>& $log
	mne_make_movie --inv $1_$exp-ave-7-meg-inv.fif --meas $1_{$exp}-ave.fif --set $c --bmin -100 --bmax -.01 --stc stc/$exp/$1_{$exp}_c{$c}-spm.stc --smooth 7 --spm >>& $log

	echo Unmorphed sLORETA >>& $log
	mne_make_movie --inv $1_$exp-ave-7-meg-inv.fif --meas $1_{$exp}-ave.fif --set $c --bmin -100 --bmax -.01 --stc stc/$exp/$1_{$exp}_c{$c}-sLORETA.stc --smooth 7 --sLORETA >>& $log

	echo Morphed mne >>& $log
	mne_make_movie --inv $1_$exp-ave-7-meg-inv.fif --meas $1_{$exp}-ave.fif --set $c --bmin -100 --bmax -.01 --stc stc/$exp/$1_{$exp}_c{$c}M-mne.stc --smooth 7 --morph fsaverage >>& $log
	
	echo Morphed spm >>& $log
	mne_make_movie --inv $1_$exp-ave-7-meg-inv.fif --meas $1_{$exp}-ave.fif --set $c --bmin -100 --bmax -.01 --stc stc/$exp/$1_{$exp}_c{$c}M-spm.stc --smooth 7 --spm --morph fsaverage >>& $log

	echo Morphed spm >>& $log	
	mne_make_movie --inv $1_$exp-ave-7-meg-inv.fif --meas $1_{$exp}-ave.fif --set $c --bmin -100 --bmax -.01 --stc stc/$exp/$1_{$exp}_c{$c}M-sLORETA.stc --smooth 7 --sLORETA --morph fsaverage >>& $log	
	
end	

########FIX GROUP ON ALL FILES########
chgrp -R lingua .