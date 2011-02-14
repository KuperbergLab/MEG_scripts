%%
clc;clear all;close all;
%%
ft_defaults;
%% electrode definitions
elec.meg = [1:306];
elec.eeg = [316:375,379:388];
o = 315;
elec.FP.l=1+o;elec.FP.r=3+o;
elec.AF.l=[4:5]+o;elec.AF.r=[7:8]+o;
elec.F.l=[9:12]+o;elec.F.r=[14:17]+o;
elec.FT.l=[18:19]+o;elec.FT.r=[27:28]+o;
elec.FC.l=[20:22]+o;elec.FC.r=[24:26]+o;
elec.T.l=[29:30]+o;elec.T.r=[38:39]+o;
elec.C.l=[31:33]+o;elec.C.r=[35:37]+o;
elec.TP.l=[40:41]+o;elec.TP.r=[49:50]+o;
elec.CP.l=[42:44]+o;elec.CP.r=[46:48]+o;
elec.P.l=[51:55]+o;elec.P.r=[[57:60]+o 64+o];
elec.PO.l=[65:66]+o;elec.PO.r=[68:69]+o;
elec.O.l=70+o;elec.O.r=72+o;
elec.mid.ant = [2 6 13 23 34] + o;
elec.mid.pos = [45 56 67 71 74] + o;
clear o
% hexants?
elec.ANT_L = [elec.FP.l elec.AF.l elec.F.l elec.FT.l elec.FC.l ];
elec.ANT_R = [elec.FP.r elec.AF.r elec.F.r elec.FT.r elec.FC.r ];
elec.POS_L = [elec.T.l elec.C.l elec.TP.l elec.CP.l elec.P.l elec.PO.l elec.O.l];
elec.POS_R = [elec.T.r elec.C.r elec.TP.r elec.CP.r elec.P.r elec.PO.r elec.O.r];
elec.ANT_M = elec.mid.ant;
elec.POS_M = elec.mid.pos;
%% preprocessing/timelockanalysis setup
exp = 'BaleenLP';
switch exp
    case 'ATLLoc'
        event_numbers = [41,42,43];
        event_names = {'Sent','Noun','String'};
        runs = {'1'};
        timee = [-60 300];
        exp1 = 'ATLLoc';
    case 'MaskedMM'
        event_numbers = [1, 2, 3, 4, 5];
        event_names = {'Direct','Indirect','Unrelated','InsectPrime','InsectTarget'};
        runs = {'1','2'};
        timee = [-60 300];
        exp1 = 'MaskedMM';
    case 'BaleenLP'
        event_numbers = [1, 2, 4, 5, 11];
        event_names = {'Related','UnrelatedTarget','UnrelatedFiller','AnimalTarget','AnimalPrime'};
        runs = {'1','2','3','4'};
        timee = [-60 420];
        exp1 = 'Baleen';
    case 'BaleenHP'
        event_numbers = [6, 7, 8, 9, 10, 12];
        event_names = {'Related','Unrelated','RelatedFiller','UnrelatedFiller','AnimalTarget','AnimalPrime'};
        runs = {'5','6','7','8'};
        timee = [-60 420];
        exp1 = 'Baleen';
end
%% not a full run?
subjects = {'2','3','4','5','6','7','8','9','12','13','15','17','19'};
% add subject-specific weirdness here
%run = {}
event_numbers = [11];
event_names = {'AnimalPrime'}

%% Loop
for event_number = event_numbers
    all_avg = cell(0,1);
    all_data = cell(0,1);
    for subject = subjects
        sub = subject{1};
        for runc = runs
            run = runc{1};
            if (strcmp(sub,'9') && strcmp(run,'6')) % || more subjects/runs 
                fprintf('\n\nBad run, skipping\n\n')
            else %good data
                % define data sets/eve
                if strcmp(exp,'ATLLoc')
                    ds = ['/cluster/kuperberg/SemPrMM/MEG/data/' sub '/' sub '_' exp1 '_raw.fif'];
                    eve = ['/cluster/kuperberg/SemPrMM/MEG/data/' sub '/eve/' sub '_' exp1 'Modblink.eve'];
                else
                    ds = ['/cluster/kuperberg/SemPrMM/MEG/data/' sub '/' sub '_' exp1 'Run' run '_raw.fif'];
                    eve = [ '/cluster/kuperberg/SemPrMM/MEG/data/' sub '/eve/' sub '_' exp1 'Run' run 'Modblink.eve'];
                end
                [data, avg] = ftsb_make_average(ds,eve,timee);
                if exist('all_data','var') == 1
                    all_data{end+1} = data;
                end
                if exist('all_avg','var') == 1
                    all_avg{end+1} = avg;
                end
                %fclose('all'); %needed because FT leaks files
            end
        end
    end
    eval([event_names{event_number == event_numbers} '_avg = all_avg; ']);
    eval([event_names{event_number == event_numbers} '_data = all_data;']);
end

% GA 
for namec = event_names
    name = namec{1};
    cfg.keepindividual = 'no';
    eval(['GA_' name '= ft_timelockgrandaverage(cfg, ' name '_avg{:});'])
    save(['GA_' exp '_' name],['GA_' name], [name '_avg'],[name '_data'],'-v7.3')
end
beep;

%% plot individuals
figure(1);clf 
chan = 27;
for iSub = 1:length(subjects)
    subplot(3,4,iSub)
    plot(GA_Sent.time,squeeze(GA_Sent.individual(iSub,chan,:)))
    hold on
    plot(GA_Noun.time,squeeze(GA_Noun.individual(iSub,chan,:)),'r')
    title(strcat('subject ya',subjects{iSub}))
    xlim([-0.1 0.4])
    ylim([-1e-12 1e-12])
    hold off
end
subplot(3,4,12); 
text(0.25,0.5,'Sent','color','b') ;text(0.25,0.3,'Noun','color','r');
text(0.25,0.1,['Channel ' GA_Sent.label{chan}],'color','k');
axis off


%% Statistics
% T Test
% cfg = [];
% cfg.channel = 'all';
% cfg.latency = 'all';
% cfg.avgovertime = 'yes';
% cfg.parameter = 'individual';
% cfg.method = 'analytic';
% cfg.statistic = 'depsamplesT';
% cfg.alpha = 0.05;
% cfg.correctm = 'bonferoni';
% Nsub = length(subjects);
% cfg.design(1,1:2*Nsub)  = [ones(1,Nsub) 2*ones(1,Nsub)];
% cfg.design(2,1:2*Nsub)  = [1:Nsub 1:Nsub];
% cfg.ivar = 1;
% cfg.uvar = 2;
% 
% stat = ft_timelockstatistics(cfg,GA_Sent,GA_Noun);

%% Non parametric MonteCarlo
% cfg = [];
% cfg.channel = 'MEG';
% cfg.latency = 'all';
% cfg.avgovertime = 'yes';
% cfg.parameter = 'individual';
% cfg.method = 'montecarlo';
% cfg.statistic = 'depsamplesT';
% cfg.alpha = 0.05;
% cfg.correctm = 'no';
% cfg.correcttail = 'prob';
% cfg.numrandomization = 10000;
% 
% Nsub = length(subjects);
% cfg.design(1,1:2*Nsub)  = [ones(1,Nsub) 2*ones(1,Nsub)];
% cfg.design(2,1:2*Nsub)  = [1:Nsub 1:Nsub];
% cfg.ivar = 1;
% cfg.uvar = 2;
% 
% stat = ft_timelockstatistics(cfg,GA_Sent,GA_Noun)

%% plot stats
%fix labels
%stat.label = cellfun(@(x) strrep(x,'MEG ',''),stat.label,'UniformOutput',false);
% make the plot
% cfg.style     = 'blank';
% cfg.layout    = 'NM306all.lay';
% cfg.highlight = 'on';
% cfg.highlightchannel = find(stat.mask);
% cfg.comment   = 'no';
% figure; ft_topoplotER(cfg, GA_Sent)
% title('Nonparametric: significant without multiple comparison correction')
%% Notepad
% %% plot?
% figure;
% for trial = 1:length(data.time)
%     plot(data.time{trial}, data.trial{trial}(POS_L,:))
%     axis([-0.1 0.4 -5e-5 5e-5])
%     title(['Trial Number: ' num2str(trial)])
%     pause(.5)
% end
% %% prepare layout
% lay = ft_prepare_layout(cfg,data)
% ft_layoutplot(cfg,data)
% %% just testing
% figure;
% hold on;
% for ii = 1:length(data.hdr.elec.pnt)
%     plot(data.hdr.elec.pnt(ii,1),data.hdr.elec.pnt(ii,2),'or')
%     pause(.1)
% end
% hold off
% 
% %% timelocked analysis 
% cfg = [];
% avgSent = ft_timelockanalysis(cfg, data_IndSent);
% avgNoun = ft_timelockanalysis(cfg, data_IndNoun);
% avgString = ft_timelockanalysis(cfg, data_IndString);
% %%
% cfg.channel = 'P9';
% ft_singleplotER(cfg,avgSent,avgNoun,avgString)
% 
% %% grandaverage 
% GA = ft_timelockgrandaverage(cfg, all_avg{:});
