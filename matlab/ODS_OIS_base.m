function [ODS, OIS] = ODS_OIS_base( algs, nms, cols )
% Plot edge precision/recall results for directory of edge images.
%
% Enhanced replacement for plot_eval() from BSDS500 code:
%  http://www.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/
% Uses same format and is fully compatible with plot_eval. Use this
% function to plot the edge results created using edgesEvalDir.
%
% USAGE
%  edgesEvalPlot( algs, [nms], [cols] )
%
% INPUTS
%  algs       - {nx1} algorithm result directories
%  nms        - [{nx1}] algorithm names (for legend)
%  cols       - [{nx1}] algorithm colors
%
% OUTPUTS
%
% EXAMPLE
%
% See also edgesEvalDir
%
% Structured Edge Detection Toolbox      Version 3.01
% Code written by Piotr Dollar, 2014.
% Licensed under the MSR-LA Full Rights License [see license.txt]

% parse inputs
if(nargin<2||isempty(nms)), nms={}; end; if(~iscell(nms)), nms={nms}; end
if(nargin<3||isempty(cols)), cols=repmat({'r','m','b','g'},1,100); end
if(~iscell(algs)), algs={algs}; end; if(~iscell(cols)), cols={cols}; end
% load results for every algorithm (pr=[T,R,P,F])
n=length(algs); hs=zeros(1,n); res=zeros(n,9); prs=cell(1,n);
for i=1:n, a=[algs{i} '-eval'];
  pr=dlmread(fullfile(a,'eval_bdry_thr.txt')); 
  pr=pr(pr(:,2)>=1e-3,:);
  [~,o]=unique(pr(:,3)); 
  R50=interp1(pr(o,3),pr(o,2),max(pr(o(1),3),.5));
  res(i,1:8)=dlmread(fullfile(a,'eval_bdry.txt')); 
  res(i,9)=R50; 
  prs{i}=pr;
end

% sort algorithms by ODS score
[~,o]=sort(res(:,4),'descend'); res=res(o,:); prs=prs(o);
cols=cols(o); if(~isempty(nms)), nms=nms(o); end

% plot results for every algorithm (plot best last)
%for i=n:-1:1
for i = 1:n
  %hs(i)=plot(prs{i}(:,2),prs{i}(:,3),'-','LineWidth',4,'Color',cols{i},'LineStyle',linestyles{i});
  [~, ord ] = sort(prs{i}(:,1));
  Xpl = prs{i}(:,2);
  Xpl = Xpl(ord);
  
  Ypl = prs{i}(:,3);
  %[Xpl, ord] = sort(Xpl);
  Ypl=Ypl(ord);
  assert(length(Xpl)==length(Ypl));
  Pos = false(length(Xpl),1);
  for ii =1 :length(Xpl)
      if all(Ypl(ii)+0.5 >= Ypl(ii+1:end)) || all(Ypl(ii)+0.5 >= Ypl(1:ii-1))
          Pos(ii)=true;
      end
  end
  
  %fprintf('ODS=%.3f OIS=%.3f AP=%.3f R50=%.3f',res(i,[4 7:9]));
  ODS = res(i,4);
  OIS = res(i,7);
  %if(~isempty(nms)), fprintf(' - %s',nms{i}); end; fprintf('\n');
end
end
