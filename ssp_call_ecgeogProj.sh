#!/bin/csh -f
#usage: ./ssp_call_ecgeogProj.sh SubjID tag par
#eg: ./ssp_call_ecgeogProj.sh ac1 ecg/eog/ecgeog ATLLoc

# setenv USE_STABLE_5_0_0
# source /usr/local/freesurfer/nmr-stable50-env
# source /usr/pubsw/packages/mne/nightly/bin/mne_setup

mkdir /autofs/cluster/kuperberg/SemPrMM/MEG/data/$1/ssp/

if ( $#argv == 0 ) then 
    echo "NO ARGUMENT SPECIFIED: Format - subjID tag paradigm"
    exit 1
endif

echo 'Computing the Projections for the subject'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$1/
echo $3

#Default Parameters
set lfreq = 5
set hfreq = 35
set magrej = 4000
set gradrej = 3000
set eegrej = 500
if $2 == 'ecg' then 
	set projtmin = -0.08
	set projtmax = 0.08
    set ngrad = 1
    set nmag = 1
    set neeg = 0
else if $2 == 'eog' then 
	set projtmin = -0.15
	set projtmax = 0.15
    set ngrad = 2
    set nmag = 2
    set neeg = 2

# elif $2 == ecgeog 
# 	set projtmin = -0.15
# 	set projtmax = 0.15
endif 

  
if $3 == 'ATLLoc' then
         echo {$1}_ATLLoc_raw.fif
         python  /cluster/kuperberg/SemPrMM/MEG/scripts/ssp_ecgeogProj.py  --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i {$1}_ATLLoc_raw.fif -c "ECG 063" --tmin $projtmin --tmax $projtmax --l-freq $lfreq --h-freq $hfreq --rej-grad $gradrej --rej-mag $magrej --rej-eeg $eegrej --bad $1_bad_chan.txt --tag $2 --average -g $ngrad -m $nmag -e $neeg
else 
	      foreach i ({$1}_{$3}Run?_raw.fif) 
		           python  /cluster/kuperberg/SemPrMM/MEG/scripts/ssp_ecgeogProj.py --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i $i -c "ECG 063" --tmin $projtmin --tmax $projtmax --l-freq $lfreq --h-freq $hfreq --rej-grad $gradrej --rej-mag $magrej --rej-eeg $eegrej --average --bad $1_bad_chan.txt --tag $2 -g $ngrad -m $nmag -e $neeg
          end
endif



#   check if tag is ecg or eog or ecgeog then run the scripts accordingly/. compute_proj_ecg_eog - to be edited to suit this structure... 
