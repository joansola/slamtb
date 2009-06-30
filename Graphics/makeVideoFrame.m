function  makeVideoFrame(Fig,filename,FigOpt,ExpOpt)

% MAKEVIDEOFRAME  Export figure to image.
%   MAKEVIDEOFRAME(FIG,FNAME,FIGOPT,EXPOPT) exports the constents of figure
%   FIG to an image with name filename, using FIGOPT and EXPOPT.

if FigOpt.createVideo
    if ~isdir(ExpOpt.root)
        mkdir(ExpOpt.root);
    end
    filepath = [ExpOpt.root filename];
    imgFrame(Fig.fig,filepath);
end

