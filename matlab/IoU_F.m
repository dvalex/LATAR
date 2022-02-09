function [IoU, dice, F] = IoU_F(gt_dir, det_dir, threshold, tol2px)
%% compute intersection over union
% for given threshold and images sets
% TODO: 1) compute precision/recall, F-measure
% TODO: 2) Use 2px tolerance if need
if nargin == 0 % DEBUG
    det_dir = 'D:\Vaxtang\CrackDetection\pavement-crack-detection\eval_tool\GUI\toy_dataset\det';
    gt_dir =  'D:\Vaxtang\CrackDetection\pavement-crack-detection\eval_tool\GUI\toy_dataset\gt';
    threshold = 0.5;
    tol2px=true;
end
gtImgList=dir([gt_dir,'/*.png']);
N = length(gtImgList);
predImgList=dir(fullfile(det_dir,'/*.mat'));
assert(length(predImgList) == N); % TODO: implement automatic comnversion png -> mat

% N is a number of testing images
Det = zeros(1,N);
TP = zeros(1,N);
FN = zeros(1,N);
parfor i = 1:N
    gt_name = gtImgList(i).name;
    
    % Load gt label and prediction
    lb = imread(fullfile(gt_dir,gt_name));   % replace with image names
    gtmask = lb > 0;
    %N1 = sum(lb(:)>0);
    
    det_name = predImgList(i).name
    pred0 = load(fullfile(det_dir, det_name));
    pred0 = pred0.predmap;
    if length(size(pred0))==3 % if pred is 3 channel, convert to gray image
        pred0 = rgb2gray(pred0);
    end
    
    predmask = pred0>=max(threshold,eps);
    if tol2px
        SE = strel('disk',2,0);
        gtmask_dilate = imdilate(gtmask, SE);
    end
    Det(i) = sum(predmask(:));
	if tol2px
		TPmask = gtmask_dilate & predmask;
	else
		TPmask = gtmask & predmask;
	end
	FNmask  = gtmask & ~predmask;
	TP(i) = sum(TPmask(:));
	FN(i) = sum(FNmask(:));
    %N2 = sum(predmask(:));
    %Inter(i) = sum(lb(:)>0 & predmask(:));
    %Union(i) = N1+N2-Inter(i) ;% A U B = A+B-A*B
end


GT = TP + FN;
%FP = Det - TP;
%Prec = sum(TP)/sum(Det);
%Rec = sum(TP) / sum(GT);
Prec = TP./(Det+eps);
Rec = TP ./(GT+eps);
Fall = (2.*Prec.*Rec)./(Prec+Rec+eps);
F=mean(Fall);
Inter = TP;
Union = Det+GT-TP;

IoU = sum(Inter) /(sum(Union)+eps);
dice = 2 * sum(Inter) /(sum(Inter) + sum(Union));
% The latter formula was used in AIU
%IoU = mean(Inter ./(Union+1));

end