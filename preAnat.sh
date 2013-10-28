#!/bin/csh -f 

#preAnat ya14 FLASH (if flash files exist) logfile
#preAnat ac1 WATER (if no flash files exist) logfile
setenv USE_STABLE_5_0_0
source /usr/local/freesurfer/nmr-stable50-env
source /usr/pubsw/packages/mne/nightly/bin/mne_setup

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 2 ) then
    set log='./preAnat.log'
    echo "Logging to default log..." >>& $log
endif

if ( $#argv == 3) then
    set log=$3
endif

# if log exists, delete
if ( -e $log ) then
    rm $log
endif


date

setenv SUBJECT $1 
set BEM_METHOD=$2

###Set up MRI images for MRILab and setup source space##

mne_setup_mri >>& $log     ##use --overwrite to recreate existing data
mne_setup_source_space  >>& $log ##use --overwrite to recreate existing data


####FLASH VS WATERSHED##################

#!/bin/csh

###Create bem surfaces IF FLASH###
if ($BEM_METHOD == FLASH) then
	###Create only if flash surfaces have not already been created### Check if the semprmm_pipeline.py --setup_bem step has been run:that puts the flash dicoms to the flash_dcm forder. 
	###(bem/flash directory is created by the mne_flash_bem script)
	if ( ! -e "/cluster/kuperberg/SemPrMM/MRI/structurals/subjects/$1/bem/flash/outer_skin.surf" ) then
		echo "flash 05 does not exist"  >>& $log
		echo "Running BEM Stuff..."  >>& $log
		mkdir $SUBJECTS_DIR/$1/bem/flash_org
		cd $SUBJECTS_DIR/$1/bem/flash_org 
		echo $SUBJECTS_DIR  >>& $log
		###ORGANIZE DICOMS IF FLASH###
		###Using full path to flash_dcm
		mne_organize_dicom /cluster/kuperberg/SemPrMM/MRI/structurals/subjects/$1/bem/flash_dcm  >>& $log
		ln -s 0*5d* flash05
		mne_flash_bem --noflash30 >>& $log   #the error for sc14/15 seems to be here
		###Create symbolic links to the bem surfaces###
		cd /cluster/kuperberg/SemPrMM/MRI/structurals/subjects/$1/bem
		rm *.surf
		ln -s ./flash/outer_skin.surf outer_skin.surf
		ln -s ./flash/outer_skull.surf outer_skull.surf
		ln -s ./flash/inner_skull.surf inner_skull.surf
	else
		echo "flash 05 exists"  >>& $log
	endif
else
	##use this if the flash surfaces don't work
	echo "Running Watershed stuff..."
	mne_watershed_bem --overwrite >>& $log
	###Create symbolic links to the bem surfaces###
	cd /cluster/kuperberg/SemPrMM/MRI/structurals/subjects/$1/bem
	rm *.surf
	ln -s ./watershed/$1_outer_skin_surface outer_skin.surf
	ln -s ./watershed/$1_outer_skull_surface outer_skull.surf
	ln -s ./watershed/$1_inner_skull_surface inner_skull.surf
	mv $SUBJECTS_DIR/$1/bem/$1-bem.fif $SUBJECTS_DIR/$1/bem/$1-orig-bem.fif
endif

#####################################

###Create surfaces for viewing

mne_setup_forward_model --surf --ico 4 >>& $log
#mne_surf2bem --surf $SUBJECTS_DIR/$1/bem/outer_skin.surf --id 4 --surf $SUBJECTS_DIR/$1/bem/outer_skull.surf --id 3 --surf $SUBJECTS_DIR/$1/bem/inner_skull.surf --id 1 --fif $SUBJECTS_DIR/$1/bem/$1-bem.fif  >>& $log
mne_make_scalp_surfaces 
mv $SUBJECTS_DIR/$1/bem/$1-head.fif $SUBJECTS_DIR/$1/bem/$1-head-old.fif
ln $SUBJECTS_DIR/$1/bem/$1-head-medium.fif $SUBJECTS_DIR/$1/bem/$1-head.fif


