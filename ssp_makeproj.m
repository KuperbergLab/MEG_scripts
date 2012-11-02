
function ssp_makeproj(subj, study, runnum)

%data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
%cd(data_subjdir);

rawfile=['/cluster/kuperberg/SemPrMM/MEG/data/',subj, '/ssp/',subj,'_', study,'Run',runnum, '_clean_ecg_raw.fif']; % raw file

projfile=['/cluster/kuperberg/SemPrMM/MEG/data/',subj, '/ssp/',subj,'_', study,'Run',runnum,'_saved_ecg-proj.fif']; % new proj filename 
info= fiff_read_meas_info(rawfile);
% indexActive=zeros(1,length(info.projs));
% 
% for i=1:length(info.projs)
% indexActive(i) = info.projs(i).active;
% indexActive(i) = 1; % to make the active projs 
% % 
% end

projdata=info.projs;

%projdata(indexActive==0)=[]; %to remove the inactive projections. 

fid = fiff_start_file(projfile);
fiff_write_proj(fid, projdata);

fclose(fid);

