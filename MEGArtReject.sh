#!/bin/csh -f
#usage: MEGArtReject.sh SubjType
#usage: subjType: sc ac or ya (in Lower case)

echo 'Clearing existing results from MEG/data/subject/ave_projon/logs folders'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
   foreach i ( $1* )
     echo $i
     cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/
     rm {$i}_MEGArtRejectATLLoc
     rm {$i}_MEGArtRejectBaleenHP
     rm {$i}_MEGArtRejectBaleenLP
     rm {$i}_MEGArtRejectMaskedMM
     rm {$i}_MEGArtReject-BadChanATLLoc
     rm {$i}_MEGArtReject-BadChanBaleenHP
     rm {$i}_MEGArtReject-BadChanBaleenLP
     rm {$i}_MEGArtReject-BadChanMaskedMM
   end 

echo 'CountEvents-CountBadChannels'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
foreach par ('ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM')
   echo $par
   foreach i ( $1* )
 #     echo $i 
      cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/
      if ($par == 'ATLLoc') then
          if ( -e /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/{$i}_{$par}-ave.log) then
              foreach t ( {$i}_{$par}*-ave.log ) 
	             python /cluster/kuperberg/SemPrMM/MEG/scripts/countBadChan.py $t $par 
              end
          endif
      else
         if (-e /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/{$i}_ATLLoc-ave.log ) then
              foreach t ( {$i}_{$par}Run?-ave.log ) 
	          python /cluster/kuperberg/SemPrMM/MEG/scripts/countBadChan.py $t $par
              end
         endif
      endif      
      cd ../../..
    end
end

echo 'Clearing existing results from MEG/results folder'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/results/MEGArtRej
   rm $1_MEGArtRejSummary-ATLLoc
   rm $1_MEGArtRejSummary-BaleenHP
   rm $1_MEGArtRejSummary-BaleenLP
   rm $1_MEGArtRejSummary-MaskedMM
   rm $1_MEGArtRejSummaryATLLoc
   rm $1_MEGArtRejSummaryBaleenHP
   rm $1_MEGArtRejSummaryBaleenLP
   rm $1_MEGArtRejSummaryMaskedMM

echo 'ComputeEvents'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
foreach par ( 'ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM' )
   echo $par
   python /cluster/kuperberg/SemPrMM/MEG/scripts/computeEvents.py $1 $par /autofs/cluster/kuperberg/SemPrMM/MEG/results/MEGArtRej/$1_MEGArtRejSummary-$par
end
    
