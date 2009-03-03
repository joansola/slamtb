%INITVIDEO  Initialize video objects for experiment

opt.fps         = 5;
opt.compression = 'none';
opt.quality     = 100;
if video == 1
    videoFile1 = [expdir 'video/' experim '-map-' mapView '.avi'];
    videoPos1  = [645 420 320 240];
    aviVideo1  = initAviFile(videoFile1,fig1,[],videoPos1,opt);
    videoFile2 = [expdir 'video/' experim '-img.avi'];
%     videoPos2  = [1 178 640 480];
    videoPos2  = [1 178 320 240];
    aviVideo2  = initAviFile(videoFile2,fig2,[],videoPos2,opt);
end
clear opt
