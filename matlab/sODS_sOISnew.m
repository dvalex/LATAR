function [sODS, sOIS, AIU, AF, Fth, IoUth] = sODS_sOISnew(det_dir, gt_dir, run_stage1, use_2px_tol)
if nargin == 0 % DEBUG
    det_dir= '.\toy_dataset\det';
    gt_dir= '.\toy_dataset\gt';
end
if nargin < 3, run_stage1 = true; end
if nargin < 4, use_2px_tol= false; end


% TODO: detect if run_stage1 is needed - maybe use files dates?
assert(isfolder(det_dir) && isfolder(gt_dir));
%det_dir = fullfile(BASE, DS, NN);
%gt_dir = fullfile(BASE, DS, 'gt');
eval_dir = [det_dir '_evalmy'];
if ~isfolder(eval_dir), mkdir(eval_dir); end
gt_files = dir(fullfile(gt_dir, '*.png'));
N = length(gt_files);
thresholds = 0.01:0.01:0.99;
n_th = length(thresholds);
%run_stage1 = true;
if run_stage1 
    tic;
    for i = 1:N
        gtname = gt_files(i).name;
        gtmask = get_mask(fullfile(gt_dir, gtname));
        if use_2px_tol
            SE = strel('disk',2,0);
            gtmask_dilate = imdilate(gtmask, SE);  
        end
            
        allGT = sum(gtmask(:))*ones(n_th, 1);
        predname = strrep(gtname, 'gt', 'pr');
        PRED = zeros(n_th, 1);
        TP  = zeros(n_th, 1);
        for t = 1:n_th
            predmask = get_mask(fullfile(det_dir, predname), thresholds(t));
            PRED(t) = sum(predmask(:));
            if use_2px_tol
		        matchmask = gtmask_dilate & predmask;
                nonmatchmask  = gtmask & ~predmask;
                fn = sum(nonmatchmask(:));
                allGT(t) = fn +  sum(matchmask(:));
            else
                matchmask = gtmask & predmask;
            end
            TP(t) = sum(matchmask(:));
            
        end
        [~, basegtname,~]= fileparts(gtname);
        fnameout = fullfile(eval_dir,  [ basegtname, '_ev1.txt']);
        fID = fopen(fnameout, 'wt'); 
        for t = 1:n_th
            fprintf(fID, '%g\t%d\t%d\t%d\t%d\n', thresholds(t), TP(t), allGT(t), TP(t), PRED(t));
        end
        fclose(fID);
    end
    fclose all;
    toc;
end

%% stage 2 - collect from files
PR_ACCUM = zeros(n_th, 4);
feval = dir (fullfile(eval_dir, '*_ev1.txt'));
assert(length(feval)==N);
F_max_arr = zeros(N,1);
F_avg_arr = zeros(N,1);
IoU = zeros(N,1);
Fall = zeros(n_th, N);
IoUall= zeros(n_th, N);
for i = 1:N
    evname = feval(i).name;
    evdata = load(fullfile(eval_dir, evname));
    assert(size(evdata,1) == n_th && size(evdata,2)==5);
    PR_ACCUM  = PR_ACCUM  + evdata(:, 2:end);

    R_i = evdata(:,2) ./ (evdata(:,3)+eps);
    P_i = evdata(:,4) ./ (evdata(:,5)+eps);
    F_i = 2*P_i .* R_i ./ (P_i+R_i+eps);
    Fall(:,i)=F_i;
    Fmax = max(F_i);
    F_max_arr(i)=Fmax;
    %concat_thrsh = sum(evdata, 1); % concatenate over all thresholds
    %IoU(i) = concat_thrsh(2)/ (concat_thrsh(3)+concat_thrsh(5)-concat_thrsh(2)+eps);
    IoUall(:,i)= evdata(:,2) ./(evdata(:,3)+evdata(:,5)-evdata(:,2)+eps);
    IoU(i) = mean(evdata(:,2) ./(evdata(:,3)+evdata(:,5)-evdata(:,2)+eps));
    F_avg_arr(i) = mean(F_i);%2*concat_thrsh(2)/ (concat_thrsh(3)+concat_thrsh(5)+eps);
    %2*TP/(2*TP+FP+FN).
end
Fth=mean(Fall,2);
IoUth = mean(IoUall,2);

AIU = mean(IoU);
AF = mean(F_avg_arr);
sOIS = mean(F_max_arr);
R_ds = PR_ACCUM(:,1) ./ PR_ACCUM(:,2);
P_ds = PR_ACCUM(:,3) ./ PR_ACCUM(:,4);
F_ds = 2*P_ds .* R_ds ./ (P_ds+R_ds);
sODS = max(F_ds);
fprintf('sODS = %g\tsOIS=%g\tAIU=%g\n', sODS, sOIS, AIU);
end



function mask = get_mask(imname, th)
if nargin < 2, th = 0.01; end
im = imread(imname);
if isa(im,'uint8') 
    mask = double(im) >= th*255.0;
    if max(im(:)) <= 1
        %warning('%s max = %d - double-check!\n', imname, max(im(:)));
    end
    return;
end

if isa(im,'uint16') 
    mask = double(im) >= th*65535.0;
    if max(im(:)) <= 1
        %warning('%s max = %d - double-check!\n', imname, max(im(:)));
    end
    return;
end



if isa(im,'logical') 
    mask = im;
    return ;
end

error('not implemented');
end


        
