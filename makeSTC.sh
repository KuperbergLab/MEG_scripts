#!/bin/csh

setenv SUBJECT $1
cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_projon

mkdir stc

#####Make stc files to subtract in Matlab####

###Unmorphed##

foreach run (1 2 3 4)  ##This is set 4, the unrelated filler in LP
	
	mne_make_movie --inv $1_BaleenRun{$run}-ave-7-meg-inv.fif --meas $1_BaleenRun{$run}-ave.fif --set 4 --bmin -100 --bmax -.01 --stc stc/$1_BaleenRun{$run}_c4-spm.stc --smooth 5 --spm
	
	foreach cond (1 2)	##This is sets 1 and 2, the targets of interest
		mne_make_movie --inv $1_BaleenRun{$run}-ave-7-meg-inv.fif --meas $1_BaleenRun{$run}-ave.fif --set $cond --bmin -100 --bmax -.01 --stc stc/$1_BaleenRun{$run}_c{$cond}-spm.stc --smooth 5 --spm
	end

end

foreach run (5 6 7 8)

	foreach cond (1 2)	##This is sets 1 and 2, the targets of interest
		mne_make_movie --inv $1_BaleenRun{$run}-ave-7-meg-inv.fif --meas $1_BaleenRun{$run}-ave.fif --set $cond --bmin -100 --bmax -.01 --stc stc/$1_BaleenRun{$run}_c{$cond}-spm.stc --smooth 5 --spm
	end
	
end

##Morphed##

foreach run (1 2 3 4)  ##This is set 4, the unrelated filler in LP
	
	mne_make_movie --inv $1_BaleenRun{$run}-ave-7-meg-inv.fif --meas $1_BaleenRun{$run}-ave.fif --set 4 --bmin -100 --bmax -.01 --stc stc/$1_BaleenRun{$run}_c4-M-spm.stc --smooth 5 --spm --morph fsaverage
	
	foreach cond (1 2)	##This is sets 1 and 2, the targets of interest
		mne_make_movie --inv $1_BaleenRun{$run}-ave-7-meg-inv.fif --meas $1_BaleenRun{$run}-ave.fif --set $cond --bmin -100 --bmax -.01 --stc stc/$1_BaleenRun{$run}_c{$cond}-M-spm.stc --smooth 5 --spm --morph fsaverage
	end

end

foreach run (5 6 7 8)

	foreach cond (1 2)	##This is sets 1 and 2, the targets of interest
		mne_make_movie --inv $1_BaleenRun{$run}-ave-7-meg-inv.fif --meas $1_BaleenRun{$run}-ave.fif --set $cond --bmin -100 --bmax -.01 --stc stc/$1_BaleenRun{$run}_c{$cond}-M-spm.stc --smooth 5 --spm --morph fsaverage
	end
	
end

########FIX GROUP ON ALL FILES########
chgrp -R lingua .

