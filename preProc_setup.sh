#!/bin/csh -f

#usage: preProc_setup.sh subjID logfile

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 1 ) then
    set log='./preProc_setup.log'
    echo "Logging to default log..." >>& $log
endif

if ( $#argv == 2) then
    set log=$2
endif

# if log exists, delete
if ( -e $log ) then
    rm $log
endif



cd /cluster/kuperberg/SemPrMM/MEG/data/$1

date >>& $log

mkdir eve -m g+rws
mkdir ave -m g+rws
mkdir cov -m g+rws
mkdir ave_projon -m g+rws
mkdir ave_projoff -m g+rws
mkdir ave_projon/logs -m g+rws
mkdir ave_projoff/logs -m g+rws
mkdir ssp -m g+rws

#########################################################
##Remove any existing *eve.fif files for internal consistency
rm *raw-eve.fif
#rm eve/*.eve
##Remove Baleen ave files with incorrect naming
rm ave*/*BaleenRun*
rm cov/*BaleenRun*

################################################################
##Save read-only copy of raw-files and make other ones writeable

if ( ! -d "raw_backup" ) then
	mkdir raw_backup
	mv *_raw.fif raw_backup
	cp raw_backup/*_raw.fif .
endif

chmod ug=rwx *_raw.fif

################################################################
##Change name of Baleen runs

mv $1_BaleenRun1_raw.fif $1_BaleenLPRun1_raw.fif
mv $1_BaleenRun2_raw.fif $1_BaleenLPRun2_raw.fif
mv $1_BaleenRun3_raw.fif $1_BaleenLPRun3_raw.fif
mv $1_BaleenRun4_raw.fif $1_BaleenLPRun4_raw.fif
mv $1_BaleenRun5_raw.fif $1_BaleenHPRun1_raw.fif
mv $1_BaleenRun6_raw.fif $1_BaleenHPRun2_raw.fif
mv $1_BaleenRun7_raw.fif $1_BaleenHPRun3_raw.fif
mv $1_BaleenRun8_raw.fif $1_BaleenHPRun4_raw.fif

#mv $1_BaleenRun1_raw_ica.mat $1_BaleenLPRun1_raw_ica.mat
#mv $1_BaleenRun2_raw_ica.mat $1_BaleenLPRun2_raw_ica.mat
#mv $1_BaleenRun3_raw_ica.mat $1_BaleenLPRun3_raw_ica.mat
#mv $1_BaleenRun4_raw_ica.mat $1_BaleenLPRun4_raw_ica.mat
#mv $1_BaleenRun5_raw_ica.mat $1_BaleenHPRun1_raw_ica.mat
#mv $1_BaleenRun6_raw_ica.mat $1_BaleenHPRun2_raw_ica.mat
#mv $1_BaleenRun7_raw_ica.mat $1_BaleenHPRun3_raw_ica.mat
#mv $1_BaleenRun8_raw_ica.mat $1_BaleenHPRun4_raw_ica.mat

#mv $1_BaleenRun1_raw.blinks $1_BaleenLPRun1_raw.blinks
#mv $1_BaleenRun2_raw.blinks $1_BaleenLPRun2_raw.blinks
#mv $1_BaleenRun3_raw.blinks $1_BaleenLPRun3_raw.blinks
#mv $1_BaleenRun4_raw.blinks $1_BaleenLPRun4_raw.blinks
#mv $1_BaleenRun5_raw.blinks $1_BaleenHPRun1_raw.blinks
#mv $1_BaleenRun6_raw.blinks $1_BaleenHPRun2_raw.blinks
#mv $1_BaleenRun7_raw.blinks $1_BaleenHPRun3_raw.blinks
#mv $1_BaleenRun8_raw.blinks $1_BaleenHPRun4_raw.blinks


#############################################################
##Extracting events read from .fif files into .eve text files

echo
echo "Extracting events" >>& $log

foreach run ('Blink' 'ATLLoc' 'MaskedMMRun1' 'MaskedMMRun2' 'BaleenLPRun1' 'BaleenLPRun2' 'BaleenLPRun3' 'BaleenLPRun4' 'BaleenHPRun1' 'BaleenHPRun2' 'BaleenHPRun3' 'BaleenHPRun4' 'AXCPTRun1' 'AXCPTRun2')
	
	if ( -e $1_{$run}_raw.fif ) then
		mne_process_raw --raw $1_{$run}_raw.fif --eventsout eve/$1_{$run}.eve --digtrig STI101 >>& $log
	endif

end

##############################################
echo
echo "Fixing triggers" >>& $log

python /cluster/kuperberg/SemPrMM/MEG/scripts/fixTriggers.py $1 >>& $log


##############################################
echo
echo "Renaming EEG channels" >>& $log

if ( $1 == 'sc19' | $1 == 'ac31') then  
	foreach f ( *_raw.fif )
		mne_rename_channels --fif $f --alias ../../scripts/function_inputs/alias0.txt >>& $log ##to rename all channels in subjects whose data was acquired post October2012- after new acq MEG system
	end
endif


if ( $1 == 'ya1' | $1 == 'ya3' |$1 == 'ya4' |$1 == 'ya7' ) then
	foreach f ( *_raw.fif )
		mne_rename_channels --fif $f --alias ../../scripts/function_inputs/alias1.txt >>& $log
		mne_check_eeg_locations --file $f --fix >>& $log
	end
endif


### NOTE: sc3 - MaskedMM Run2 has its last two channels names different and in the reverse order. So to fix that, whenever you re-run preProc_setup, edit the alias3.txt file to reflect the following changes 1) RMAST --> MISC 115 and 2) EEG 099 --> RMAST .
### This has to be done in 2 steps and only for MM2 to match with channels of MM1 for averaging purpose.  
if ( $1 == 'sc3' ) then  
	foreach f ( *MMRun2_raw.fif )
		mne_rename_channels --fif $f --alias ../../scripts/function_inputs/alias3.txt >>& $log ##to rename EEG 99 channel aquired in sc3 - MaskedMM Run2 as MISC 115, to create averages across runs. 
	end
endif


foreach f ( *_raw.fif )
        mne_rename_channels --fif $f --alias ../../scripts/function_inputs/alias2.txt >>& $log
end


##############################################
###Marking bad channels

echo
echo "Marking bad channels" >>& $log

if ( -e $1_bad_chan.txt ) then
	foreach f ( *_raw.fif )
		mne_mark_bad_channels --bad $1_bad_chan.txt $f >>& $log
	end
endif

echo
date
echo "Finished preProc - setup" >>& $log
