function [data,ave] = ftsb_make_average(ds,eve,num,t)
cfg = [];
cfg.sb.eve = eve;
cfg.sb.num = num;
cfg.dataset = ds;
cfg.trialfun = 'ftsb_event_reader';
cfg.sb.time = t;
cfg = ft_definetrial(cfg);
cfg.channel = {'MEG*'};
cfg.continuous = 'yes';
cfg.lpfilter = 'yes';
cfg.lpfreq = 40;
cfg.demean = 'yes';

data = ft_preprocessing(cfg);
ave = ft_timelockanalysis(cfg,data);
