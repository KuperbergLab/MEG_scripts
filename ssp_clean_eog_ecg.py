"""Clean a raw file from EOG and ECG artifacts with PCA (ie SSP)
"""

# Authors : Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
#           Engr. Nandita Shetty,  MS.
#           Alexandre Gramfort, Ph.D.

##ex: python ../../scripts/clean_eog_ecg.py -i ac1_BaleenHPRun1_raw.fif

import os
import mne
from mne import fiff


def clean_eog_ecg(in_fif_fname, out_fif_fname=None, ecg_proj_fname=None,
                  eog_proj_fname=None, ecg_event_fname=None,
                  eog_event_fname=None, in_path='.'):
    """Clean ECG from raw fif file

    Parameters
    ----------
    in_fif_fname: string
        Raw fif File
    eog_event_fname: string
        name of EOG event file required.
    ecg_event_fname: string
        name of ECG event file required.
    in_path:
        Path where all the files are.
    """
    # Reading fif File
    raw_in = fiff.Raw(in_fif_fname)

    if in_fif_fname.endswith('_raw.fif') or in_fif_fname.endswith('-raw.fif'):
        prefix = in_fif_fname[:-8]
    else:
        prefix = in_fif_fname[:-4]
	print in_fif_fname
    if out_fif_fname is None:
        out_fif_fname = prefix + '_clean_ecg_eog_raw.fif'
    if ecg_proj_fname is None:
        ecg_proj_fname = prefix + '_ecg_proj.fif'
    if eog_proj_fname is None:
        eog_proj_fname = prefix + '_eog_proj.fif'
    if ecg_event_fname is None:
        ecg_event_fname = prefix + '_ecg-eve.fif'
    if eog_event_fname is None:
        eog_event_fname = prefix + '_eog-eve.fif'
        
    flag = 0

    print 'Implementing ECG and EOG artifact rejection on data'

    ecg_events, _, _ = mne.artifacts.find_ecg_events(raw_in)
    if not len(ecg_events) < 30:
		print ecg_event_fname
		print "Writing ECG events in %s" % ecg_event_fname
		mne.write_events(ecg_event_fname, ecg_events)
	
		# Making projector
		print 'Computing ECG projector'
	
		command = ('mne_process_raw --cd %s --raw %s --events %s --makeproj '
				   '--projtmin -0.08 --projtmax 0.08 --saveprojtag _ecg_proj '
				   '--projnmag 1 --projngrad 1 --projneeg 1 --projevent 999 --highpass 5 '
				   '--lowpass 35 --projmagrej 4000  --projgradrej 3000 --projeegrej 500'
				   % (in_path, in_fif_fname, ecg_event_fname))
		st = os.system(command)
		if st != 0:
			print "Error while running : %s" % command

		
	####################################################

    eog_events = mne.artifacts.find_eog_events(raw_in)    
    if not len(eog_events) < 20:
		print "Writing EOG events in %s" % eog_event_fname
		mne.write_events(eog_event_fname, eog_events)
	
		print 'Computing EOG projector'
	
		command = ('mne_process_raw --cd %s --raw %s --events %s --makeproj '
				   '--projtmin -0.15 --projtmax 0.15 --saveprojtag _eog_proj '
				   '--projnmag 1 --projngrad 1 --projneeg 1 --projevent 998 --lowpass 35 '
				   '--projmagrej 4000  --projgradrej 3000 --projeegrej 500' % (in_path,
				   in_fif_fname, eog_event_fname))	
		print 'Running : %s' % command	
		st = os.system(command)
		if st != 0:
			raise ValueError('Problem while running : %s' % command)


#################################################################
    if (not len(ecg_events) < 30) and (not len(eog_events) < 20):
        # Applying the ECG EOG projector
        print 'Applying ECG EOG projector'
        command = ('mne_process_raw --cd %s --raw %s --proj %s --proj %s --proj %s '
                   '--projoff --save %s --filteroff'
                   % (in_path, in_fif_fname, ecg_proj_fname, eog_proj_fname, in_fif_fname,
                   out_fif_fname))
        print 'Command executed: %s' % command
        st = os.system(command)
        if st != 0:
            raise ValueError('Pb while running : %s' % command)
        print ('Done removing ECG and EOG artifacts. '
               'IMPORTANT : Please eye-ball the data !!')
        print "ECG ",len(ecg_events), "EOG ", len(eog_events)   
               
    elif (not len(eog_events) < 20):
    	out_fif_fname = prefix + '_clean_eog_raw.fif'
    	print 'Applying EOG projector'
    	command = ('mne_process_raw --cd %s --raw %s --proj %s --proj %s '
                   '--projoff --save %s --filteroff'
                   % (in_path, in_fif_fname, eog_proj_fname, in_fif_fname,
                   out_fif_fname))
    	print 'Command executed: %s' % command
    	st = os.system(command)
    	if st != 0:
    		raise ValueError('Pb while running : %s' % command)
    	print ('Done removing EOG artifacts. '
               'IMPORTANT : Please eye-ball the data !!')
        print "EOG ", len(eog_events) 
 
    elif (not len(ecg_events) < 30):
    	out_fif_fname = prefix + '_clean_ecg_raw.fif'
    	print 'Applying ECG projector'
    	command = ('mne_process_raw --cd %s --raw %s --proj %s --proj %s '
                   '--projoff --save %s --filteroff'
                   % (in_path, in_fif_fname, ecg_proj_fname, in_fif_fname,
                   out_fif_fname))
    	print 'Command executed: %s' % command
    	st = os.system(command)
    	if st != 0:
    		raise ValueError('Pb while running : %s' % command)
    	print ('Done removing ECG artifacts. '
               'IMPORTANT : Please eye-ball the data !!')
        print "ECG ", len(ecg_events)


if __name__ == '__main__':

    from optparse import OptionParser

    parser = OptionParser()
    parser.add_option("-i", "--in", dest="raw_in",
                    help="Input raw FIF file", metavar="FILE")
    parser.add_option("-o", "--out", dest="raw_out",
                    help="Input raw FIF file", metavar="FILE",
                    default=None)

    (options, args) = parser.parse_args()

    raw_in = options.raw_in
    raw_out = options.raw_out

    clean_eog_ecg(raw_in, raw_out)
