#!/bin/csh

#usage: preProc_reject subjID logfile

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 1 ) then
    set log='./preProc_reject.log'
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
date

#reject.m is made with pipeline
if ( -e rej/reject.m ) then
    matlab7.11 -nosplash -nodesktop -nodisplay < /cluster/kuperberg/SemPrMM/MEG/data/$1/rej/reject.m >>& $log
    # now write out new ModRej.eve files
    python /cluster/kuperberg/SemPrMM/MEG/scripts/rej2eve.py $1 >>& $log
    # now save comparison data
    python /cluster/kuperberg/SemPrMM/MEG/scripts/cmpEve.py $1 >>& $log
else
    echo "No reject.m file was found" >>& $log
    exit 1
endif


