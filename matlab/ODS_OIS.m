function [ODS, OIS] = ODS_OIS(resDir, gtDir, runStage1)
if nargin == 0 % DEBUG
    resDir = 'D:\Vaxtang\CrackDetection\pavement-crack-detection\eval_tool\GUI\toy_dataset\det';
    gtDir =  'D:\Vaxtang\CrackDetection\pavement-crack-detection\eval_tool\GUI\toy_dataset\gt';
    runStage1 = true;
end
if runStage1
    edgesEvalDir_crack('resDir',resDir,'gtDir',gtDir, 'thin', 1, 'pDistr',{{'type','parfor'}},'maxDist',0.0075);
end
%edgesEvalPlot(resDir,'model');
[ODS, OIS] = ODS_OIS_base( resDir,'model');
fclose all;
end