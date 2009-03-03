%INITVIDEO  Initialize video objects for experiment


% if video == 1
%     aviopt = struct(...
%         'fps',5,...
%         'compression','none',...
%         'quality',100);
%     videoFile1 = [expdir 'video/' experim '-' expType '-map-top.avi'];
%     videoPos1  = [645 420 320 240];
%     aviVideo1  = initAviFile(videoFile1,fig1,[],videoPos1,aviopt);
%     videoFile2 = [expdir 'video/' experim '-' expType '-map-side.avi'];
%     figure(fig1)
%     camorbit(0,-90)
%     aviVideo2  = initAviFile(videoFile2,fig1,[],videoPos1,aviopt);
%     camorbit(0,90)
%     aviopt = struct(...
%         'fps',5,...
%         'compression','none',...
%         'quality',100);
%     videoFile3 = [expdir 'video/' experim '-' expType '-img.avi'];
%     videoPos3  = [1   1  959 360];
%     aviVideo3  = initAviFile(videoFile3,fig2,[],videoPos3,aviopt);
% end

% FROM FISSLAM-NO-ODO  --  needs adaptation
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
        videoPosMap  = [1 450 320 240];
        seqFileMapTop = [expdir 'sequences/fis-' expType '/' experim '-map-top-%04d.png'];
        seqFileMapSide = [expdir 'sequences/fis-' expType '/' experim '-map-side-%04d.png'];
        set(fig1,'pos',videoPosMap);
        set(ax1,'cameraviewangle',60);
        imgFrame(fig1,sprintf(seqFileMapTop,fmin-1));
        camorbit(ax1,0,-90)
        imgFrame(fig1,sprintf(seqFileMapSide,fmin-1));
        camorbit(ax1,0,90)
        seqFileImg = [expdir 'sequences/fis-' expType '/' experim '-img-%04d.png'];
        videoPosImg  = [1 1 960 360];
        set(fig2,'pos',videoPosImg);
        set(ax2(1),'pos',[0 0 0.5 1])
        set(ax2(2),'pos',[0.5 0 0.5 1])
        imgFrame(fig2,sprintf(seqFileImg,fmin-1));
        
        if plotCalib
            videoPosCalib = [370 450 320 240];
            seqFileCalib = [expdir 'sequences/fis-' expType '/' experim '-calib-%04d.png'];
            set(fig4,'pos',videoPosCalib);
            imgFrame(fig4,sprintf(seqFileCalib,fmin-1));
        end
end
clear opt
