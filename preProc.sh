#!/bin/csh

#usage: preProc subjID preBlinkTime postBlinkTime
#example: preproc ya16 -0.1 0.4

cd /cluster/kuperberg/SemPrMM/MEG/data/$1

date

mkdir eve -m g+rws
mkdir ave -m g+rws
mkdir cov -m g+rws
mkdir ave_projon -m g+rws
mkdir ave_projoff -m g+rws
mkdir ave_projon/logs -m g+rws
mkdir ave_projoff/logs -m g+rws


################################################################
##Save read-only copy of raw-files and make other ones writeable

if ( ! -d "raw_backup" ) then
	mkdir raw_backup
	cp *_raw.fif raw_backup
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

#############################################################
##Extracting events read from .fif files into .eve text files

echo
echo "Extracting events"

foreach run ('Blink' 'ATLLoc' 'MaskedMMRun1' 'MaskedMMRun2' 'BaleenLPRun1' 'BaleenLPRun2' 'BaleenLPRun3' 'BaleenLPRun4' 'BaleenHPRun5' 'BaleenHPRun6' 'BaleenHPRun7' 'BaleenHPRun8' 'AXCPTRun1' 'AXCPTRun2')
	
	if ( -e $1_{$run}_raw.fif ) then
		mne_process_raw --raw $1_{$run}_raw.fif --eventsout eve/$1_{$run}.eve
	endif

end

##############################################
echo
echo "Fixing triggers"

python /cluster/kuperberg/SemPrMM/MEG/scripts/fixTriggers.py $1


##############################################
echo
echo "Renaming EEG channels"

if ( $1 == 'ya1' | $1 == 'ya3' |$1 == 'ya4' |$1 == 'ya7' ) then
	foreach f ( *_raw.fif )
		mne_rename_channels --fif $f --alias ../../scripts/alias1.txt
		mne_check_eeg_locations --file $f --fix
	end
endif


foreach f ( *_raw.fif )
	mne_rename_channels --fif $f --alias ../../scripts/alias2.txt
end


##############################################
###Marking bad channels

echo
echo "Marking bad channels"

if ( -e $1_bad_chan.txt ) then
	foreach f ( *_raw.fif )
		mne_mark_bad_channels --bad $1_bad_chan.txt $f
	end
endif

echo


###########################
echo
echo "Making Ave Parameter Files"
python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py $1 $2 $3

echo
echo "Making blink .eve Files"
python /cluster/kuperberg/SemPrMM/MEG/scripts/blinkEveFiles.py $1 $2 $3

echo
echo "Making Cov Parameter Files"
python /cluster/kuperberg/SemPrMM/MEG/scripts/makeCovFiles.py $1 $2 $3


##############################
####AVERAGING#################

foreach proj ( 'projoff' 'projon')

	cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_$proj

	mne_process_raw \
	--raw ../$1_ATLLoc_raw.fif \
	--ave ../ave/$1_ATLLoc.ave \
	--$proj --lowpass 20 --highpass .5

	mne_process_raw \
	--raw ../$1_MaskedMMRun1_raw.fif \
	--raw ../$1_MaskedMMRun2_raw.fif \
	--ave ../ave/$1_MaskedMMRun1.ave \
	--ave ../ave/$1_MaskedMMRun2.ave \
	--gave $1_MaskedMM_All-ave.fif \
	--$proj --lowpass 20

	mne_process_raw \
	--raw ../$1_BaleenLPRun1_raw.fif \
	--raw ../$1_BaleenLPRun2_raw.fif \
	--raw ../$1_BaleenLPRun3_raw.fif \
	--raw ../$1_BaleenLPRun4_raw.fif \
	--ave ../ave/$1_BaleenLPRun1.ave \
	--ave ../ave/$1_BaleenLPRun2.ave \
	--ave ../ave/$1_BaleenLPRun3.ave \
	--ave ../ave/$1_BaleenLPRun4.ave \
	--gave $1_BaleenLP_All-ave.fif \
	--$proj --lowpass 20

	mne_process_raw \
	--raw ../$1_BaleenHPRun1_raw.fif \
	--raw ../$1_BaleenHPRun2_raw.fif \
	--raw ../$1_BaleenHPRun3_raw.fif \
	--raw ../$1_BaleenHPRun4_raw.fif \
	--ave ../ave/$1_BaleenHPRun1.ave \
	--ave ../ave/$1_BaleenHPRun2.ave \
	--ave ../ave/$1_BaleenHPRun3.ave \
	--ave ../ave/$1_BaleenHPRun4.ave \
	--gave $1_BaleenHP_All-ave.fif \
	--$proj --lowpass 20


	if ( -e ../$1_AXCPTRun1_raw.fif ) then
		if ( -e ../$1_AXCPTRun2_raw.fif ) then
			mne_process_raw \
			--raw ../$1_AXCPTRun1_raw.fif \
			--raw ../$1_AXCPTRun2_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--ave ../ave/$1_AXCPTRun2.ave \
			--gave $1_AXCPT_All-ave.fif \
			--$proj --lowpass 20
		else
			mne_process_raw \
			--raw ../$1_AXCPTRun1_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--$proj --lowpass 20
			cp $1_AXCPTRun1-ave.fif $1_AXCPT_All-ave.fif
		endif
	endif

	####################################

	echo "Counting events"
	
	python /cluster/kuperberg/SemPrMM/MEG/scripts/countEvents.py $1 0 ATLLoc 1 $proj
	python /cluster/kuperberg/SemPrMM/MEG/scripts/countEvents.py $1 0 MaskedMM 2 $proj
	python /cluster/kuperberg/SemPrMM/MEG/scripts/countEvents.py $1 0 Baleen 8 $proj
	

end

#######################################
####COMPUTING COVARIANCE FOR PROJON####
echo Computing covariance
 
mne_process_raw \
 --raw ../$1_MaskedMMRun1_raw.fif \
 --raw ../$1_MaskedMMRun2_raw.fif \
 --cov ../cov/$1_MaskedMMRun1.cov \
 --cov ../cov/$1_MaskedMMRun2.cov \
 --gcov $1_MaskedMM_All-cov.fif \
 --projon --lowpass 20
 
mne_process_raw \
 --raw ../$1_BaleenLPRun1_raw.fif \
 --raw ../$1_BaleenLPRun2_raw.fif \
 --raw ../$1_BaleenLPRun3_raw.fif \
 --raw ../$1_BaleenLPRun4_raw.fif \
 --raw ../$1_BaleenHPRun1_raw.fif \
 --raw ../$1_BaleenHPRun2_raw.fif \
 --raw ../$1_BaleenHPRun3_raw.fif \
 --raw ../$1_BaleenHPRun4_raw.fif \
 --cov ../cov/$1_BaleenLPRun1.cov \
 --cov ../cov/$1_BaleenLPRun2.cov \
 --cov ../cov/$1_BaleenLPRun3.cov \
 --cov ../cov/$1_BaleenLPRun4.cov \
 --cov ../cov/$1_BaleenHPRun1.cov \
 --cov ../cov/$1_BaleenHPRun2.cov \
 --cov ../cov/$1_BaleenHPRun3.cov \
 --cov ../cov/$1_BaleenHPRun4.cov \
 --gcov $1_Baleen_All-cov.fif \
 --projon --lowpass 20
 

if ( -e ../$1_AXCPTRun1_raw.fif ) then
	if ( -e ../$1_AXCPTRun2_raw.fif ) then
		mne_process_raw \
		--raw ../$1_AXCPTRun1_raw.fif \
		--raw ../$1_AXCPTRun2_raw.fif \
		--cov ../cov/$1_AXCPTRun1.cov \
		--cov ../cov/$1_AXCPTRun2.cov \
		--gcov $1_AXCPT_All-cov.fif \
		--projon --lowpass 20
	else
		mne_process_raw \
		--raw ../$1_AXCPTRun1_raw.fif \
		--cov ../cov/$1_AXCPTRun1.cov \
		--gcov $1_AXCPT_All-cov.fif \
		--projon --lowpass 20		
	endif
endif


echo FINISHED
cd /cluster/kuperberg/SemPrMM/MEG/data/$1

########FIX GROUP ON ALL FILES########
chgrp -R lingua .