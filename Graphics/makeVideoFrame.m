function  makeVideoFrame(Fig,filename,FigOpt,ExpOpt)

% MAKEVIDEOFRAME  Export figure to image.
%   MAKEVIDEOFRAME(FIG,FNAME,FIGOPT,EXPOPT) exports the constents of figure
%   FIG to an image with name filename, using FIGOPT and EXPOPT.

if FigOpt.createVideo
    dir = [ExpOpt.root ExpOpt.lmkTypes '/' ExpOpt.sensingType '/'];
    if ~isdir(dir)
        mkdir(dir);
    end
    filepath = [dir filename];
    imgFrame(Fig.fig,filepath);
end

