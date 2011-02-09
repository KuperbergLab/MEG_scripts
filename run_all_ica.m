function run_all_ica(subject_cell)
warning off all

for s = subject_cell
    subject = s{1};
    fif2wts(subject,pwd);
    fifwts2blinks(subject,pwd);
    sendmail('sburns@nmr.mgh.harvard.edu',['finished ica for ' subject]);
end

exit;
