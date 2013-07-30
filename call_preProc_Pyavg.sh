#!/bin/csh -f
## Usage ./call_preProc_Pyavg.sh subjectType paradigm


cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
#foreach par ('BaleenHP' 'BaleenLP' 'ATLLoc' 'MaskedMM')
foreach par ('MaskedMM')
echo $2
foreach i (`cat /autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/$1.meg.all.txt`)   
         set subj = $1$i
         echo $subj
         python  /cluster/kuperberg/SemPrMM/MEG/scripts/preProc_avg.py $subj $2
end
