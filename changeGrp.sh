#!/bin/csh
#usage: MEGArtReject.sh SubjType

# subjType: sc ac or ya 
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
   foreach i ( $1* )
     echo $i
     cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/
     pwd 
     chgrp lingua {$i}_MEGArtRejectATLLoc
     chgrp lingua  {$i}_MEGArtRejectBaleenHP
     chgrp lingua {$i}_MEGArtRejectBaleenLP
     chgrp lingua  {$i}_MEGArtRejectMaskedMM
   end 

cd /autofs/cluster/kuperberg/SemPrMM/MEG/results/MEGArtRej
    pwd
    chgrp lingua  {$1}_MEGArtRejSummaryATLLoc
    chgrp lingua  {$1}_MEGArtRejSummaryBaleenHP
    chgrp lingua  {$1}_MEGArtRejSummaryBaleenLP
    chgrp lingua  {$1}_MEGArtRejSummaryMaskedMM
