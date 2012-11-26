function ssp_sensitivity(subj, study, runnum)

rawfile = ['/cluster/kuperberg/SemPrMM/MEG/data/',subj, '/ssp/',subj,'_', study,'Run',runnum, '_clean_ecg8_raw.fif'];
fwdfile = ['/cluster/kuperberg/SemPrMM/MEG/data/',subj,'/ave_projon/', subj,'_', study,'Run',runnum,'-ave-7-meg-fwd.fif']; 
info = fiff_read_meas_info(rawfile)
info.projs(9:end)=[];


for i=1:length(info.projs)
 info.projs(i).active=1;
end

proj8 = ['/cluster/kuperberg/SemPrMM/MEG/data/', subj, '/ssp/',subj,'_', study,'Run',runnum, '_saved2_ecg8-proj.fif'];
fid = fiff_start_file(proj8);
fiff_write_proj(fid, info.projs);
fclose(fid);
w8 =  ['/cluster/kuperberg/SemPrMM/MEG/data/', subj, '/ssp/',subj,'_', study,'Run',runnum, '_saved2_ecg8Projmag'];

info.projs(5:8)=[];
proj4 = ['/cluster/kuperberg/SemPrMM/MEG/data/', subj, '/ssp/',subj,'_', study,'Run',runnum,'_saved2_ecg4-proj.fif'];
fid = fiff_start_file(proj4);
fiff_write_proj(fid, info.projs);
fclose(fid);
w4 =  ['/cluster/kuperberg/SemPrMM/MEG/data/', subj, '/ssp/',subj,'_', study,'Run',runnum, '_saved2_ecg4Projmag'];

info.projs(3:4)=[];
proj2 = ['/cluster/kuperberg/SemPrMM/MEG/data/',subj, '/ssp/',subj,'_', study,'Run',runnum,'_saved2_ecg2-proj.fif'];
fid = fiff_start_file(proj2);
fiff_write_proj(fid, info.projs);
fclose(fid);
w2 =  ['/cluster/kuperberg/SemPrMM/MEG/data/', subj, '/ssp/',subj,'_', study,'Run',runnum, '_saved2_ecg2Projmag'];

command=sprintf('mne_sensitivity_map --fwd %s --proj %s --mag --map 5 --w %s', fwdfile, proj2, w2);
unix(command)

command=sprintf('mne_sensitivity_map --fwd %s --proj %s --mag --map 5 --w %s', fwdfile, proj4, w4);
unix(command)
 
command=sprintf('mne_sensitivity_map --fwd %s --proj %s --mag --map 5 --w %s', fwdfile, proj8, w8);
unix(command)

w2lh = [w2, '-lh.w'];
w2rh = [w2, '-rh.w'];
lh=mne_read_w_file(w2lh);
rh=mne_read_w_file(w2rh);
data2=[lh.data;rh.data];


w4lh = [w4, '-lh.w'];
w4rh = [w4, '-rh.w'];
lh=mne_read_w_file(w4lh);
rh=mne_read_w_file(w4rh);
data4=[lh.data;rh.data];


w8lh = [w8, '-lh.w'];
w8rh = [w8, '-rh.w'];
lh=mne_read_w_file(w8lh);
rh=mne_read_w_file(w8rh);
data8=[lh.data;rh.data];


hist(data2,100);title('2')
print('-f1', '-dpng', w2)
figure;hist(data4,100);title('4')
print('-f2', '-dpng', w4)
figure;hist(data8,100);title('8')
print('-f3', '-dpng', w8)

