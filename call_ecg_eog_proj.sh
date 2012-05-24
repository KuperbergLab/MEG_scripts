#!/bin/csh -f
#usage: ./call_ecg_eog_proj.sh SubjID tag par
#eg: ./call_ecg_eog_proj.sh ac1 ecg/eog/ecgeog ATLLoc

# setenv USE_STABLE_5_0_0
# source /usr/local/freesurfer/nmr-stable50-env
# source /usr/pubsw/packages/mne/nightly/bin/mne_setup

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
else if $2 == 'eog' then 
	set projtmin = -0.15
	set projtmax = 0.15
# elif $2 == ecgeog 
# 	set projtmin = -0.15
# 	set projtmax = 0.15
endif 


## including this to remove the _avg_proj files created in the first trial in yas.
#if $3 == 'ATLLoc' then 
# 					   rm {$1}_ATLLoc_{$2}_avg_proj_raw.fif
# 					   rm {$1}_ATLLoc_{$2}_avg_proj_raw-eve.fif
# 					   rm {$1}_ATLLoc_{$2}_avg_proj.fif
# 					   rm {$1}_ATLLoc_{$2}-eve.fif
#else 
# 					   rm {$1}_{$3}Run?_{$2}_avg_proj_raw.fif
# 					   rm {$1}_{$3}Run?_{$2}_avg_proj_raw-eve.fif
# 					   rm {$1}_{$3}Run?_{$2}_proj_raw.fif
# 					   rm {$1}_{$3}Run?_{$2}_proj_raw-eve.fif
# 					   rm {$1}_{$3}Run?_{$2}_avg_proj.fif
# 					   rm {$1}_{$3}Run?_{$2}-eve.fif  
#endif

  
if $3 == 'ATLLoc' then
         echo {$1}_ATLLoc_raw.fif
         python  /cluster/kuperberg/SemPrMM/MEG/scripts/mne_proj_ecg_eog.py  --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i {$1}_ATLLoc_raw.fif -c "ECG 063" --tmin $projtmin --tmax $projtmax --l-freq $lfreq --h-freq $hfreq --rej-grad $gradrej --rej-mag $magrej --rej-eeg $eegrej --bad $1_bad_chan.txt --tag $2 --average
else 
	     foreach i ({$1}_{$3}Run?_raw.fif)
		          python  /cluster/kuperberg/SemPrMM/MEG/scripts/mne_proj_ecg_eog.py --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i $i -c "ECG 063" --tmin $projtmin --tmax $projtmax --l-freq $lfreq --h-freq $hfreq --rej-grad $gradrej --rej-mag $magrej --rej-eeg $eegrej --average --bad $1_bad_chan.txt --tag $2		      			 
	     end
endif



#   check if tag is ecg or eog or ecgeog then run the scripts accordingly/. compute_proj_ecg_eog - to be edited to suit this structure... 
