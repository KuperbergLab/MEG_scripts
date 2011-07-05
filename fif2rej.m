function fif2rej(fiff, do_plot)
%------------------------
%
% Writes out 5 text files, each with two columns.
% First column is time point (in samples) and next is
% channel on which that time point should be rejected
%
% Inputs
%   fiff - fif file path
%   (optional) do_plot - 1 if you'd like to visualize rejections, 0 if not
%------------------------

if nargin < 1
    fiff = '/cluster/kuperberg/SemPrMM/MEG/data/ya1/ya1_ATLLoc_raw.fif';
    chan_c = {'grad', 'mag', 'eeg'};
    chan_c = {'veog'};
    do_plot = 0
elseif nargin < 2
    chan_c = {'veog', 'heog', 'eeg'};
    do_plot = 0;
end


%%%%%%%%%
% find the appropriate rej_thr.txt file
[~, n, ~] = fileparts(fiff);
ind = find(n == '_', 1, 'first');
sub = n(1:ind-1);
sub_thr = ['/cluster/kuperberg/SemPrMM/MEG/data/' sub '/rej/rej_thr.txt'];
if exist(sub_thr, 'file')
    disp('Using subject specific thresholds...')
    rej_path = sub_thr;
else
    disp('Using default thresholds...')
    rej_path = '/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/rej_thr.txt';
end
S = importdata(rej_path);

% find each rej thr
[~, i] = ismember(S.textdata, 'veog');
veog_rej = S.data(i == 1);


[~, i] = ismember(S.textdata, 'heog');
heog_rej = S.data(i == 1);

[~, i] = ismember(S.textdata, 'eeg');
eeg_rej = S.data(i == 1);

[~, i] = ismember(S.textdata, 'grad');
grad_rej = S.data(i == 1);

[~, i] = ismember(S.textdata, 'mag');
mag_rej = S.data(i == 1);

for chan = chan_c
    chan_str = chan{1};
        switch chan_str
            case 'veog'
                chans = 377;
                meth = 'win';
                thr = veog_rej;
                f = @window;
            case 'heog'
                chans = 376;
                meth = 'win';
                thr = heog_rej;
                f = @window;
            case 'grad'
                chans = sort([1:3:306 2:3:306]);
                meth = 'peak2peak';
                thr = grad_rej;
                f = @peak2peak;
            case 'mag'
                chans = 3:3:306;
                meth = 'peak2peak';
                thr = mag_rej;
                f = @peak2peak;
            case 'eeg'
                chans = [316:375 379:389];
                meth = 'peak2peak';
                thr = eeg_rej;
                f = @peak2peak;
            otherwise
                error('Bad chan_str specifier')
        end

    %build new filename
    [p, n, ~] = fileparts(fiff);
    new_fn = [n '_' chan_str '.txt'];
    tmp = fullfile(p, 'rej');
    if exist(tmp, 'dir') ~= 8
        [status, ~, ~] = mkdir(tmp);
        if status ~= 1
            error(['Cannot make ' tmp]);
        end
    end
    new_path = fullfile(tmp, new_fn);

    % some output
    fprintf('\n\nfiff: %s\ndata: %s\nmethod: %s\nrejection file: %s\n\n', fiff, chan_str, meth, new_path);

    % load data
    ds = fiff_setup_read_raw(fiff);
    
    % don't load bad chan
    [~, ia, ~] = intersect(ds.info.ch_names, ds.info.bads);
    [~, ib, ~] = intersect(chans, ia);
    chans(ib) = [];
    
    X = fiff_read_raw_segment(ds,ds.first_samp,ds.last_samp,chans);
    Xm = detrend(X', 'constant')';
    
    % compute bad sample points
    bad_mat = f(Xm, thr, ds, chans, do_plot);

    %remove known bad channels
    for ch = unique(bad_mat(:,2))'
        if length(ds.info.bads) > 1
            if any(ismember(ds.info.bads, ds.info.ch_names(ch)))
                bad_mat = setdiff(bad_mat, bad_mat(bad_mat(:,2) == ch,:),'rows');
            end
        end
    end

    % write out bad samples
    fprintf('Writing results to %s\n', new_path);
    dlmwrite(new_path, bad_mat, 'delimiter', '\t', 'precision', '%d');

    clear X Xm bad_mat new_path new_fn tmp
end

end

function bad_mat = window(X, thr, ds, chans, p)
fprintf('Running window rejection method...\n')
N = length(X);
w = 60; %each window is 60 samples long
mat_ind = 1;
bad_mat = zeros(N,2);
first = double(ds.first_samp);
n = 2:N-1;
tic
for ii = n
    pre_ind = ii-1:-1:ii-w;
    pre_m = mean(X(pre_ind(pre_ind > 0)));
    post_ind = ii+1:ii+w;
    post_m = mean(X(post_ind(post_ind <= N)));
    d = post_m - pre_m;
    if d > thr || d < -thr
        tp = first + ii;
        bad_mat(mat_ind,:) = [tp chans];
        mat_ind = mat_ind + 1;
    end
end
bad_mat = bad_mat(1:mat_ind-1,:);
fprintf('Finished window rejection method in %3.3f s\n', toc)
if p
    t = double(ds.first_samp):double(ds.last_samp);
    [n, x] = hist(bad_mat(:,1), length(X));
    n(1,2) = 0;
    figure(chans);close(chans);figure(chans);
    hold on;plot(t,X,'b');bar(x, n/10000,'r'); hold off;
end
end

function bad_mat = flat(X, thr, ds, chans, p)
fprintf('Running flat rejection method...\n')
[r, c] = find(X > thr | X < -thr);
bad_mat = zeros(length(r), 2);
first = double(ds.first_samp);
for ii = 1:length(r)
    bad_mat(ii, :) = [first+c(ii) chans(r(ii))];
end
if p
    close all;
    c = 254;
    ci = chans == c;
    dat = X(ci,:);
    [r, ~] = find(bad_mat(:,2) == c);
    b_ch = bad_mat(r,1);
    [n, x] = hist(b_ch, length(dat));
    n(1,2) = 0;
    figure(1);close 1;figure(1);
    t = double(ds.first_samp):double(ds.last_samp);
    hold on;plot(t,dat,'b');bar(x, n/(1/thr)); hold off;
end
fprintf('Finished flat rejection method...\n')
end

function bad_mat = peak2peak(X, thr, ds, chans, p)
fprintf('Running peak-to-peak rejection method...\n')
w = 600;
bad_mat = zeros(length(X)*20,2);
% bad_mat = [];
mat_ind = 1;
first = double(ds.first_samp);
npasses = 1:length(X)-w;
tic
for ii = npasses
    win = X(:,ii:ii+w);
    [ma, ix] = max(win, [], 2);
    [mi, in] = min(win, [], 2);
    [r, ~] = find((ma - mi) > thr | (ma - mi) < -thr);
    if length(r) > 1
        ir = r(1);
    %     for jj = 1:length(r)
    %         ir = r(jj);
        if abs(ma(ir)) > abs(mi(ir))
            bt = ix(ir)+first+ii;
        else
            bt = in(ir)+first+ii;
        end
        to_add = [bt chans(ir)];
        bad_mat(mat_ind, :) = to_add;
        mat_ind = mat_ind + 1;
    end
%     end
end
bad_mat = bad_mat(1:mat_ind-1,:);
bad_mat = unique(bad_mat, 'rows');
t = toc;
fprintf('Finished peak-to-peak method in %3.3f s\n', t);
if p
    un_ch = unique(bad_mat(:,2));
    for c = un_ch'
        ci = find(chans == c);
        dat = X(ci, :);
        [r, ~] = find(bad_mat(:,2) == c);
        b_ch = bad_mat(r,1);
        [n, x] = hist(b_ch, length(dat));
        n(1,2) = 0;
        figure(c);close(c);figure(c);
        t = double(ds.first_samp):double(ds.last_samp);
        hold on;plot(t,dat,'b');bar(x, n/(1/thr)); hold off;
    end
end
end