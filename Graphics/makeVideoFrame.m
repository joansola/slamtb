function  makeVideoFrame(Fig,filename,FigOpt,ExpOpt)

% MAKEVIDEOFRAME  Export figure to image.
%   MAKEVIDEOFRAME(FIG,FNAME,FIGOPT,EXPOPT) exports the constents of figure
%   FIG to an image with name filename, using FIGOPT and EXPOPT as options.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

dir = [ExpOpt.root 'figures/' ExpOpt.lmkTypes '/' ExpOpt.sensingType '/images/'];
if ~isdir(dir)
    mkdir(dir);
end
filepath = [dir filename];
imgFrame(Fig.fig,filepath);










