#!/bin/csh -f
#usage: ./ssp_call_ecgeogProj.sh SubjID tag par clean
#eg: ./ssp_call_ecgeogProj.sh ac1 ecg/eog/ecgeog ATLLoc clean

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

set ngrad = 1
set nmag = 1
set neeg = 1 
##10/1/12 Using new set of projectors for ECG(1mag, 1grad, 0eeg-specified in ssp_clean_ecgeogProj.py script) and EOG(1mag 1grad 1eeg).

#Default Parameters
set magrej = 4000
set gradrej = 3000
set eegrej = 500
if $2 == 'ecg' then 
    set lfreq = 35
    set hfreq = 5
    set projtmin = -0.08
    set projtmax = 0.08
    set ngrad = 1
    set nmag = 1 
    set neeg = 0
else if $2 == 'eog' then
    set lfreq = 35
    set hfreq = 0.3 
    set projtmin = -0.2
    set projtmax = 0.2
    set ngrad = 1
    set nmag = 1 
    set neeg = 1 ##2nd ssp vector had no/negative effect so changed back to 1 ##changed back to 3 after modifying HPF 

else if $2 == 'ecgeog' then
    set lfreq = 35
    set hfreq = 0.3 
    set projtmin = -0.2
    set projtmax = 0.2
endif 

if $4 == 'clean' then

			if $3 == 'ATLLoc' then
				 echo {$1}_ATLLoc_raw.fif                                  
				 python  /cluster/kuperberg/SemPrMM/MEG/scripts/ssp_clean_ecgeogProj.py  --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i {$1}_ATLLoc_raw.fif -c "ECG 063" --tmin $projtmin --tmax $projtmax --l-freq $lfreq --h-freq $hfreq --rej-grad $gradrej --rej-mag $magrej --rej-eeg $eegrej --bad $1_bad_chan.txt --tag $2 -g $ngrad -m $nmag -e $neeg
                                 mv /cluster/kuperberg/SemPrMM/MEG/data/$1/{$1}_ATLLoc_ecg_proj.fif /cluster/kuperberg/SemPrMM/MEG/data/$1/ssp/
                                 mv /cluster/kuperberg/SemPrMM/MEG/data/$1/{$1}_ATLLoc_eog_proj.fif /cluster/kuperberg/SemPrMM/MEG/data/$1/ssp/
			else 
				  foreach i ({$1}_{$3}Run?_raw.fif)
						   python  /cluster/kuperberg/SemPrMM/MEG/scripts/ssp_clean_ecgeogProj.py --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i $i -c "ECG 063" --tmin $projtmin --tmax $projtmax --l-freq $lfreq --h-freq $hfreq --rej-grad $gradrej --rej-mag $magrej --rej-eeg $eegrej --tag $2 
                                                                           
				  end
#  				  mv /cluster/kuperberg/SemPrMM/MEG/data/$1/ssp/{$1}_{$3}Run?_eog_proj.fif /cluster/kuperberg/SemPrMM/MEG/data/$1/
#  				  mv /cluster/kuperberg/SemPrMM/MEG/data/$1/{$1}_{$3}Run?_ecg_proj.fif /cluster/kuperberg/SemPrMM/MEG/data/$1/ssp/
#  				  mv /cluster/kuperberg/SemPrMM/MEG/data/$1/{$1}_{$3}Run?_ecgeog_proj.fif /cluster/kuperberg/SemPrMM/MEG/data/$1/ssp/

			endif

    
endif




# if $3 == 'ATLLoc' then
# 	 echo {$1}_ATLLoc_raw.fif                                  
# 	 python  /cluster/kuperberg/SemPrMM/MEG/scripts/ssp_ecgeogProj.py  --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i {$1}_ATLLoc_raw.fif -c "ECG 063" --tmin $projtmin --tmax $projtmax --l-freq $lfreq --h-freq $hfreq --rej-grad $gradrej --rej-mag $magrej --rej-eeg $eegrej --bad $1_bad_chan.txt --tag $2 -g $ngrad -m $nmag -e $neeg --bad $1_bad_chan.txt
# 					 mv /cluster/kuperberg/SemPrMM/MEG/data/$1/{$1}_ATLLoc_ecg_proj.fif /cluster/kuperberg/SemPrMM/MEG/data/$1/ssp/
# 					 mv /cluster/kuperberg/SemPrMM/MEG/data/$1/{$1}_ATLLoc_eog_proj.fif /cluster/kuperberg/SemPrMM/MEG/data/$1/ssp/
# else 
# 	  foreach i ({$1}_{$3}Run1_raw.fif) 
# 			   python  /cluster/kuperberg/SemPrMM/MEG/scripts/ssp_ecgeogProj.py --in_path /cluster/kuperberg/SemPrMM/MEG/data/$1/ -i $i -c "ECG 063" --tmin $projtmin --tmax $projtmax --l-freq $lfreq --h-freq $hfreq --rej-grad $gradrej --rej-mag $magrej --rej-eeg $eegrej --tag $2 -g $ngrad -m $nmag -e $neeg --bad $1_bad_chan.txt
# 															   
# 	  end
# 	  mv /cluster/kuperberg/SemPrMM/MEG/data/$1/ssp/{$1}_{$3}Run?_eog_proj.fif /cluster/kuperberg/SemPrMM/MEG/data/$1/
# # 				  mv /cluster/kuperberg/SemPrMM/MEG/data/$1/{$1}_{$3}Run?_ecg_proj.fif /cluster/kuperberg/SemPrMM/MEG/data/$1/ssp/
# # 				  mv /cluster/kuperberg/SemPrMM/MEG/data/$1/{$1}_{$3}Run?_ecgeog_proj.fif /cluster/kuperberg/SemPrMM/MEG/data/$1/ssp/
# 
# endif


#   check if tag is ecg or eog or ecgeog then run the scripts accordingly/. compute_proj_ecg_eog - to be edited to suit this structure... 
