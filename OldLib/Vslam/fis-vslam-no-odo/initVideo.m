%INITVIDEO  Initialize video objects for experiment

switch video
    case 1 % AVI file
        opt.fps         = 5;
        opt.compression = 'none';
        opt.quality     = 100;
        videoPosMap  = [1 1 320 240];
        videoFileMapTop = [expdir 'video/' experim '-map-top.avi'];
        aviVideoMapTop  = initAviFile(videoFileMapTop,fig1,[],videoPosMap,opt);
%         videoFileMapSide = [expdir 'video/' experim '-map-top.avi'];
%         aviVideoSide  = initAviFile(videoFileMapSide,fig1,[],videoPosMap,opt);

        videoFileImg = [expdir 'video/' experim '-img.avi'];
        %     videoPosImg  = [1 178 320 240];
        videoPosImg  = [1 229 640 480];
        aviVideoImg  = initAviFile(videoFileImg,fig2,[],videoPosImg,opt);
    case 2 % images sequence
        videoPosMap  = [700 2 480 360];
        seqFileMapTop = [expdir 'sequences/' experim '-map-top-%04d.png'];
        seqFileMapSide = [expdir 'sequences/' experim '-map-side-%04d.png'];
        set(fig1,'pos',videoPosMap);
        imgFrame(fig1,sprintf(seqFileMapTop,fmin-1));
        camorbit(ax1,0,-90)
        imgFrame(fig1,sprintf(seqFileMapSide,fmin));
        camorbit(ax1,0,90)
        seqFileImg = [expdir 'sequences/' experim '-img-%04d.png'];
        videoPosImg  = [200 2 480 360];
        set(fig2,'pos',videoPosImg);
        set(ax21,'pos',[0 0 1 1])
        imgFrame(fig1,sprintf(seqFileMapSide,fmin-1));
        imgFrame(fig2,sprintf(seqFileImg,fmin-1),ax21);
end
clear opt
