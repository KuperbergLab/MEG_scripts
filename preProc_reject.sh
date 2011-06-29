#!/bin/bash

#usage: preProc_reject subjID

cd /cluster/kuperberg/SemPrMM/MEG/data/$1
date

#reject.m is made with pipeline
if [ -e rej/reject.m ] ; then
    matlab7.11 -nosplash -nodesktop -nodisplay < /cluster/kuperberg/SemPrMM/MEG/data/$1/rej/reject.m
    # now write out new ModRej.eve files
    python /cluster/kuperberg/SemPrMM/MEG/scripts/rej2eve.py $1
    # now save comparison data
    python /cluster/kuperberg/SemPrMM/MEG/scripts/cmpEve.py $1
else
    echo "No reject.m file was found"
    exit 1
fi


