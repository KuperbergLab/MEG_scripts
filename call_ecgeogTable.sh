#!/bin/csh -f
#usage: ./call_ecgeogTable.sh SubjID
#eg: ./call_ecgeogTable.sh  ac1  



cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$1
if ( -e {$1}_ecgeog_eventsTable.txt ) then
		rm {$1}_ecgeog_eventsTable.txt
endif

echo 'Creating the ecgeogTable for the subject' $1
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$1

echo "Paradigm	ECG_PulseRate EOG_Events" >> {$1}_ecgeog_eventsTable.txt
foreach par ('ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM')
#foreach par ('MaskedMM')
	if $par == 'ATLLoc' then
		  echo {$1}_ATLLoc_raw.fif
		  python /cluster/kuperberg/SemPrMM/MEG/scripts/ecgeogTable.py {$1}_ATLLoc_raw.fif $par $1 {$1}_ecgeog_eventsTable.txt "ECG 063" 
	else 
		  foreach i ({$1}_{$par}Run?_raw.fif) 
			echo $i			      
			python /cluster/kuperberg/SemPrMM/MEG/scripts/ecgeogTable.py $i $par $1 {$1}_ecgeog_eventsTable.txt "ECG 063" 
		  end
	endif
end
chgrp lingua {$1}_ecgeog_eventsTable.txt