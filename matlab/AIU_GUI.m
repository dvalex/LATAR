function aiu = AIU_GUI(det_dir, gt_dir)
%fprintf('%s %s\n', DS, NET);
if nargin == 0 % DEBUG
    det_dir= '.\toy_dataset\det';
    gt_dir= '.\toy_dataset\gt';
end
get_pIUPR(det_dir, gt_dir);
aiu = get_AIU(det_dir);
end

function get_pIUPR(resultsPath,gruImgPath)
%% compute pIU (IU for positives), precion, and recall on each image over diifferent threshold
class_num = 4;
if ~(exist([resultsPath,'-evalIu'],'dir')==7)
    mkdir([resultsPath,'-evalIu']);
end
outputpath=[resultsPath,'-evalIu'];
predImgList=dir([resultsPath,'/*.mat']);
gruImgList=dir([gruImgPath,'/*.png']);
% num denotes number of testing images
for i = 1:length(gruImgList)
%%!!!! make parfor!!!!
%for i = 1:100%length(gruImgList)
    fname = gruImgList(i).name;
    gtname = strrep(fname, '-predicted-resized', '');
    fid=fopen(fullfile(outputpath,[gtname(1:end-3),'txt']),'w');
    % Load gt label and prediction
    lb = imread(fullfile(gruImgPath,gtname));   % replace with image names
    lb(lb>0)=1;
    lb=lb+1;
    pred0 = load(fullfile(resultsPath,predImgList(i).name));
    pred0 = pred0.predmap;
    if length(size(pred0))==3 % if pred is 3 channel, convert to gray image
        pred0 = rgb2gray(pred0);
    end
    
    for threshold = 0.01:0.01:0.99
        confusion = zeros(class_num) ;
        pred = (pred0>=max(threshold,eps))+1;
        % Accumulate errors, 0 is ignored
        lin_comb = 10*double(lb)+pred;
        confusion(1,1) = sum(lin_comb(:)==11);
        confusion(1,2) = sum(lin_comb(:)==12);
        confusion(2,1) = sum(lin_comb(:)==21);
        confusion(2,2) = numel(lin_comb) - confusion(1,1) - confusion(1,2)...
            - confusion(2,1);
        [pIU,precision,recall] = getMetrics(confusion);
        fprintf(fid,'%10g %10g %10g %10g\n',[threshold pIU precision recall]');
    end
    fclose(fid);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function aiu = get_AIU(resultsDir)
%% compute mean pIU, precision, recall over dataset
suffix='-evalIu';
evalImgPath=[resultsDir,suffix];
fullfile(evalImgPath,['mTpIUPR','.txt']);
ImgList=dir([evalImgPath,'/*.txt']);
mTpIUPR=0;% mean evaluation metrics over dataset
IU=[];
for imgInd=1:length(ImgList)
    % load evaluation metrics pIU, Precision, Recall over each Threshold (TpIUPR) for each image
    TpIUPR=importdata(fullfile(evalImgPath,[ImgList(imgInd).name(1:end-3),'txt']));
    if size(TpIUPR,2)==4
        mTpIUPR=mTpIUPR+TpIUPR;
        IU = [IU; mean(TpIUPR(:,2))];
    end
end
mTpIUPR=mTpIUPR/length(ImgList);
fid=fopen(fullfile(evalImgPath,['mTpIUPR','.txt']),'w');
fprintf(fid,'%10g %10g %10g %10g\n',mTpIUPR');
fclose(fid);
aiu = mean(mTpIUPR(:,2));
fprintf('AIU %.4f\n',aiu);
end
% -------------------------------------------------------------------------
function [pIU,precision,recall] = getMetrics(confusion)
% -------------------------------------------------------------------------
pos = sum(confusion,2) ;%positives
res = sum(confusion,1)' ;%results
tp = diag(confusion);
fp=res - tp;
precision=tp./max(eps,(tp+fp));
precision=precision(2);
recall=tp./pos;
recall=recall(2);
IU = tp ./ max(1, pos + res - tp);
pIU=IU(2);%IU for positives
end
