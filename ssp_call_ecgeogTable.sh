#!/bin/csh -f
#usage: ./ssp_call_ecgeogTable.sh SubjID
#eg: ./ssp_call_ecgeogTable.sh  ac1  



cd /autofs/cluster/kuperberg/SemPrMM/MEG/results/artifact_rejection/ecgeogTable/
if ( -e {$1}_ecgeog_eventsTable.txt ) then
		rm {$1}_ecgeog_eventsTable.txt
                rm ../../../data/$1/{$1}_ecgeog_eventsTable.txt
endif

echo "Paradigm	ECG_PulseRate EOG_PerMin" >> {$1}_ecgeog_eventsTable.txt


echo 'Creating the ecgeogTable for the subject' $1
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$1


foreach par ('ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM')
#foreach par ('ATLLoc')
	if $par == 'ATLLoc' then
		  echo {$1}_ATLLoc_raw.fif
		  python /cluster/kuperberg/SemPrMM/MEG/scripts/ssp_ecgeogTable.py {$1}_ATLLoc_raw.fif $par $1 {$1}_ecgeog_eventsTable.txt "ECG 063" 
	else 
		  foreach i ({$1}_{$par}Run?_raw.fif) 
			echo $i			      
			python /cluster/kuperberg/SemPrMM/MEG/scripts/ssp_ecgeogTable.py $i $par $1 {$1}_ecgeog_eventsTable.txt "ECG 063" 
		  end
	endif
end
chgrp lingua ../../results/artifact_rejection/ecgeogTable/{$1}_ecgeog_eventsTable.txt
