#!/bin/csh -f
#usage: ./call_ecg_eog_proj.sh SubjID tag par
#eg: ./call_ecg_eog_proj.sh ac1 ecg/eog/ecgeog ATLLoc

# setenv USE_STABLE_5_0_0
# source /usr/local/freesurfer/nmr-stable50-env
# source /usr/pubsw/packages/mne/nightly/bin/mne_setup

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

echo 'Computing the Projections for the subject'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$1/
echo $3 
   
if $3 == 'ATLLoc' then
         echo {$1}_ATLLoc_raw.fif
         python  /cluster/kuperberg/SemPrMM/MEG/scripts/mne_compute_proj_ecg_eog.py  --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i {$1}_ATLLoc_raw.fif -c "ECG 063" --rej-grad 2000 --rej-mag 3000 --rej-eeg 100 --average --bad $1_bad_chan.txt --tag $2
#          mne_process_raw \
# 		 --cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ \
# 		 --raw /cluster/kuperberg/SemPrMM/MEG/data/$1/$1_ATLLoc_raw.fif \
# 		 --proj /cluster/kuperberg/SemPrMM/MEG/data/$1/$1_ATLLoc_ecg_avg_proj.fif \
# 		 --projoff /cluster/kuperberg/SemPrMM/MEG/data/$1/$1_ATLLoc_raw.fif \
# 	     --save /cluster/kuperberg/SemPrMM/MEG/data/$1/$1_ATLLoc_ecg_avg_proj_raw.fif \
# 		 --filteroff
else 
	     foreach i ({$1}_{$3}Run?_raw.fif) 
		          python  /cluster/kuperberg/SemPrMM/MEG/scripts/mne_compute_proj_ecg_eog.py --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i $i -c "ECG 063" --rej-grad 2000 --rej-mag 3000 --rej-eeg 100 --average --bad $1_bad_chan.txt --tag $2		      			 
	     end
endif



#   check if tag is ecg or eog or ecgeog then run the scripts accordingly/. compute_proj_ecg_eog - to be edited to suit this structure... 
