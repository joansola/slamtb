%INITVIDEO  Initialize video objects for experiment


if video == 1
    aviopt = struct(...
        'fps',5,...
        'compression','none',...
        'quality',100);
    videoFile1 = [expdir 'video/' experim '-' expType '-map-top.avi'];
    videoPos1  = [645 420 320 240];
    aviVideo1  = initAviFile(videoFile1,fig1,[],videoPos1,aviopt);
    videoFile2 = [expdir 'video/' experim '-' expType '-map-side.avi'];
    figure(fig1)
    camorbit(0,-90)
    aviVideo2  = initAviFile(videoFile2,fig1,[],videoPos1,aviopt);
    camorbit(0,90)
    aviopt = struct(...
        'fps',5,...
        'compression','none',...
        'quality',100);
    videoFile3 = [expdir 'video/' experim '-' expType '-img.avi'];
    videoPos3  = [1   1  959 360];
    aviVideo3  = initAviFile(videoFile3,fig2,[],videoPos3,aviopt);
end
