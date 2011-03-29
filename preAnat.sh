#!/bin/csh

#preAnat ya14 FLASH (if flash files exist)
#preAnat ac1 WATER (if no flash files exist)

date

setenv SUBJECT $1 
set BEM_METHOD=$2

###Set up MRI images for MRILab and setup source space##

mne_setup_mri
mne_setup_source_space


####FLASH VS WATERSHED##################

#!/bin/csh

###Create bem surfaces IF FLASH###
if ($BEM_METHOD == FLASH) then
	###Create only if flash surfaces have not already been created###
	###(bem/flash directory is created by the mne_flash_bem script)
	if ( ! -e "/cluster/kuperberg/SemPrMM/MRI/structurals/subjects/$1/bem/flash/outer_skin.surf" ) then
		echo "flash 05 does not exist"
		echo "Running BEM Stuff..."
		cd $SUBJECTS_DIR/$1/bem/flash_org
		echo $SUBJECTS_DIR
		###ORGANIZE DICOMS IF FLASH###
		mne_organize_dicom ../flash_dcm
		ln -s 0*5d* flash05
		mne_flash_bem --noflash30
		###Create symbolic links to the bem surfaces###
		cd /cluster/kuperberg/SemPrMM/MRI/structurals/subjects/$1/bem
		ln -s ./flash/outer_skin.surf outer_skin.surf
		ln -s ./flash/outer_skull.surf outer_skull.surf
		ln -s ./flash/inner_skull.surf inner_skull.surf
	else
		echo "flash 05 exists"
	endif
else
	##use this if the flash surfaces don't work
	echo "Running Watershed stuff..."
	mne_watershed_bem  
	###Create symbolic links to the bem surfaces###
	cd /cluster/kuperberg/SemPrMM/MRI/structurals/subjects/$1/bem
	ln -s ./watershed/outer_skin.surf outer_skin.surf
	ln -s ./watershed/outer_skull.surf outer_skull.surf
	ln -s ./watershed/inner_skull.surf inner_skull.surf
endif

#####################################

###Create surfaces for viewing

mne_setup_forward_model --surf --ico 4

mne_surf2bem --surf $SUBJECTS_DIR/$1/bem/outer_skin.surf --id 4 --surf $SUBJECTS_DIR/$1/bem/outer_skull.surf --id 3 --surf $SUBJECTS_DIR/$1/bem/inner_skull.surf --id 1 --fif $SUBJECTS_DIR/$1/bem/$1-bem.fif


