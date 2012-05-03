#!/bin/csh -f
#usage: ./call_ecg_eog_proj.sh SubjID tag par
#eg: ./call_ecg_eog_proj.sh ac1 ecg/eog/ecgeog ATLLoc

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

echo 'Run mne_compute_proj_ecg.py for the subject'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/

echo $3 
   
if $3 == 'ATLLoc' then
         echo {$1}_ATLLoc_raw.fif
         python  /cluster/kuperberg/SemPrMM/MEG/scripts/mne_compute_proj_ecg_eog.py  --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i {$1}_ATLLoc_raw.fif -o {$1}_ATLLoc_proj_ecg_raw.fif -c "ECG 063" --rej-grad 2000 --rej-mag 3000 --rej-eeg 100 --average --bad $1_bad_chan.txt --tag $2

else 
	 foreach i ({$1}_{$3}Run?_raw.fif) 
		 echo $i
                 python  /cluster/kuperberg/SemPrMM/MEG/scripts/mne_compute_proj_ecg_eog.py  --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i $i -o {$1}_{$3}Run?_proj_eog_raw.fif -c "ECG 063" --rej-grad 2000 --rej-mag 3000 --rej-eeg 100 --average --bad $1_bad_chan.txt --tag $2		      			 
	 end
endif



#   check if tag is ecg or eog or ecgeog then run the scripts accordingly/. compute_proj_ecg_eog - to be edited to suit this structure... 
