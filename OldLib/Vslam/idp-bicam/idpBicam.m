% FISBICAM  Federated Information Sharing SLAM with two cameras.
%   Visual undelayed 3D-SLAM. This is the full algorithm with
%   data acquisition, image processing, tracking and SLAM.

% Copyright 2003-2006 Joan Sola @ LAAS-CNRS

clear ; clear global

% Experiment variables
experim     = 'serie29';
expType     = 'bicam';
imType      = 'originals';

% Simulation options. On landmarks and map management
keepBack    = -8;   % Minimum depth in the map
reproject   = 1;    % Recompute jacobians at each lmk update
% fmin        = 20;
% fmax        = 25; % -1: take fmax = Nframes -1
load batch_calib_.mat fmin fmax
randSeed    = -1; % Make this run repeatable. -1: true random

% Visualization options
mapView     = 'top';    % Map v5iew {top,normal,side,view}
mapProj     = 'ortho';  % Map projection type {orthographic,perspective}
equalizeIm  = 0;        % Image gidp equalization
plotVray    = 0;        % Show virtual idp
plotPatches = 0;        % Show landmark's patches figure
plotUsed    = 0;        % Show map usage
plotCalib   = 1;        % Show extrinsic self-calibration
video       = 0;        % 0: no video; 1: avi; 2: JPG images
videoSide   = 0;        % Capture side views of the map for video



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% AUTOMATIC INITIALIZATIONS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% some nice things
format compact
home
fprintf('\n This is FIS-SLAM!\n\n\n');
if randSeed < 0
    clk = clock;
    randSeed = floor(100*clk(6)) % Make this run imprevisible but show seed
end
rand('state',randSeed);randn('state',randSeed);
fmin,fmax

% Root experiment directory
expdir   = [...
    '~/Documents/Doctorat/slam/Experiments/Dala/' ...
    experim '/'];
imgdir   = [expdir 'images/' imType '/'];
figdir   = [expdir 'figures/'];
loadfile = [expdir experim '-' expType '.mat'];

imgname{1} = 'image.%03d.g'; % left image
imgname{2} = 'image.%03d.d'; % right image

% Read real data files -> set {Nframes, nOdo, camera}
load(loadfile);

% Initialize simulation variables
if (fmax < 0 || fmax >= Nframes), fmax = Nframes-1; end
if fmax < fmin, fmax = fmin; end
initConst;
initRobot;
initCamera;
initLmks;
initMap;
initImage;
lastUsedIdps   = zeros(1,Lmk.maxIdp); % last frame's used idps

% Initialize visualizations
initMapFig;
initImageFig;
initCalibFig;
initPatchesFig;
initVideo;
%
%  END OF INITIALIZATIONS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TIME EVOLUTION
%
%%%%%%%%%%%%%%%%%
%
% The sequence for each loop is:
%   1.  Landmark observations: filter corrections at frame f
%   2.  Visualizations:        filter state at frame f
%   3.  Motions:               filter transition to frame f+1
%

for f = fmin:fmax
    % for f = 10:30
    %======================================================
    %
    % 1. LANDMARK OBSERVATIONS
    %==========================
    %
    % The sequence is:
    %   1.a  Take two photos
    %   1.b  Project points into images
    %   1.c  Select points with biggest dU to correct
    %   1.d  Observe Np points
    %   1.e  Project idps and delete non visible ones
    %   1.f  Select Nr idps with big projected ellipses
    %   1.g  Observe Nr idps
    %   1.h  Get Harris points in unpopulated image regions and
    %         initialize new idps
    %

    %------------------------------------------------------
    %
    % 1.a) Take two photos
    %----------------------

    Image{1}  = oneShot([imgdir imgname{1}],f,equalizeIm);
    Image{2}  = oneShot([imgdir imgname{2}],f,equalizeIm);
    dispImage = displImage(dispImage);              % Display image

    %
    %------------------------------------------------------




    %------------------------------------------------------
    %
    % 1.b) Project points onto images
    %---------------------------------

    for i = find([Lmk.Pnt.used])
        for cam = 1:2
            Lmk.Pnt(i) = projectPnt(...
                Rob,...
                Cam(cam),...
                Lmk.Pnt(i),...
                Obs.R);
        end
        Lmk.Pnt(i) = summarizePnt(Lmk.Pnt(i));
    end

    % delete points behind camera
    backPnts = [Lmk.Pnt.used] & ([Lmk.Pnt.s] < keepBack);
    for i = find(backPnts)
        Lmk.Pnt(i).used = false;
        liberateMap(Lmk.Pnt(i).loc);
    end
    %
    %------------------------------------------------------




    %------------------------------------------------------
    %
    % 1.c) Select points with biggest dU to correct
    %-----------------------------------------------

    % visible points
    visPnts = [Lmk.Pnt.used] & [Lmk.Pnt.vis0];

    % sort dU
    [bigdU,bigVisPnts] = sBiggest(...
        Lmk.Pnt(visPnts),...
        'dUmax');

    % indices to biggest-dU visible points
    visPnts = find(visPnts);
    bigPnts = visPnts(bigVisPnts);
    %
    %------------------------------------------------------




    %------------------------------------------------------
    %
    % 1.d) Observe points
    %---------------------
    %
    % Por each point to observe, the sequence is
    %
    %   i. Search patch
    %  ii. Good match
    % iii. Bad or no match

    updates = 0;   % number of updates counter
    for i = bigPnts % for each point to observe

        for cam = 1:2 % with each camera

            if Lmk.Pnt(i).Prj(cam).vis % visible points only

                % re-project point to get actual linearizations
                if reproject
                    Lmk.Pnt(i) = projectPnt(...
                        Rob,...
                        Cam(cam),...
                        Lmk.Pnt(i),...
                        Obs.R);
                end

                % i. Search patch
                Lmk.Pnt(i).Prj(cam).region = pnt2par(...
                    Lmk.Pnt(i),...
                    ns,...
                    cam,...
                    patchSize); %  region to scan

                Lmk.Pnt(i).wPatch = patchResize(...
                    Lmk.Pnt(i).sig,...
                    Lmk.Pnt(i).Prj(cam).sr^-1); % warp patch

                [ Lmk.Pnt(i).Prj(cam).y,...
                    Lmk.Pnt(i).Prj(cam).sc,...
                    Lmk.Pnt(i).Prj(cam).cPatch] ...
                    ...
                    = patchScan(...
                    ...
                    cam,...
                    Lmk.Pnt(i).wPatch,...
                    Lmk.Pnt(i).Prj(cam).region,...
                    Lmk.Pnt(i).Prj(cam).region.x0,...
                    .1,...
                    .89);

                pixFound = (Lmk.Pnt(i).Prj(cam).sc > foundPixTh);

                if pixFound % Pixel found

                    Lmk.Pnt(i).Prj(cam).matched = 1;
                    Obs.y   = Lmk.Pnt(i).Prj(cam).y;

                    Lmk.Pnt(i)         = uPntInnovation(...
                        Lmk.Pnt(i),...
                        cam,...
                        Obs.y,...
                        Obs.R);

                else  % Pixel not found

                    Lmk.Pnt(i).Prj(cam).matched = 0;
                    Lmk.Pnt(i).Prj(cam).y       = [];

                end

                pixGood = pixFound && (Lmk.Pnt(i).Prj(cam).MD < MDth);

                % ii. Good match
                if pixGood
                    Lmk.Pnt(i).Prj(cam).updated = 1;
                    Lmk.Pnt(i).lost    = 0;

                    % move landmark
                    Lmk.Pnt(i) = moveLandmark(Lmk.Pnt(i));

                    % correct map
                    [Rob,Cam(cam)] = lmkCorrection(...
                        Rob,...
                        Cam(cam),...
                        Lmk.Pnt(i));

                    updates = updates + 1;

                else  % iii. Bad or no match

                    Lmk.Pnt(i).Prj(cam).updated = 0;
                    Lmk.Pnt(i).lost = Lmk.Pnt(i).lost + 1;

                end % good or bad match

            end % visible point

        end % cameras


        if Lmk.Pnt(i).lost > lostPntTh
            % delete landmark
            Lmk.Pnt(i).used = false;
            liberateMap(Lmk.Pnt(i).loc);
        else
            % move landmark
            Lmk.Pnt(i) = moveLandmark(Lmk.Pnt(i));
        end


        if updates >= Lmk.simultPnt
            break
        end

    end % points

    % end of point observations
    %------------------------------------------------------




    %------------------------------------------------------
    %
    % 1.e) Project idps
    %-------------------

    for i = find([Lmk.Idp.used])
        for cam = 1:length(Cam)
            Lmk.Idp(i) = projectIdp(...
                Rob,...
                Cam(cam),...
                Lmk.Idp(i),...
                Obs.R);
        end
        Lmk.Idp(i) = summarizeIdp(Lmk.Idp(i));
    end


    % Delete non visible idps
    nonVisIdps = lastUsedIdps & ~[Lmk.Idp.vis0];
    for i = find(nonVisIdps)
        Lmk.Idp(i).used = false;
        loc = Lmk.Idp(i).loc;
        liberateMap(loc);
    end

    % Remember previous idps' indices
    lastUsedIdps = [Lmk.Idp.used];
    %
    %------------------------------------------------------




    %------------------------------------------------------
    %
    % 1.f) Select idps with biggest dU to correct
    %---------------------------------------------

    % visible idps (without those just initialized)
    lastVisIdps = lastUsedIdps & [Lmk.Idp.vis0];

    % sort dUmax
    [bigdU,bigVisIdps] = sBiggest(...
        Lmk.Idp(lastVisIdps),...
        'dUmax');

    % indices to biggest-dU visible idps
    bigIdps = find(lastVisIdps);
    bigIdps = bigIdps(bigVisIdps);
    %
    %------------------------------------------------------





    %------------------------------------------------------
    %
    % 1.g) Observe idps
    %
    % Por each idp to observe, the sequence is
    %
    %   i. Search patch
    %  ii. Good match
    % iii. Bad or no match

    updates = 0; % Updated idps counter
    for i = bigIdps

        for cam = 1:length(Cam) % for each camera


            % re-project idp to get actual linearizations
            if reproject
                Lmk.Idp(i) = projectIdp(...
                    Rob,...
                    Cam(cam),...
                    Lmk.Idp(i),...
                    Obs.R);
            end


            if Lmk.Idp(i).Prj(cam).vis  % visible idps only

                % i. Search patch
                Lmk.Idp(i).wPatch          = patchResize(...
                    Lmk.Idp(i).sig,...
                    Lmk.Idp(i).Prj(cam).sr^-1);

                Lmk.Idp(i).Prj(cam).region = idp2par(...
                    Lmk.Idp(i),...
                    ns,...
                    cam,...
                    patchSize); % region to scan

                [ Lmk.Idp(i).Prj(cam).y,...
                    Lmk.Idp(i).Prj(cam).sc,...
                    Lmk.Idp(i).Prj(cam).cPatch] = patchScan(...
                    cam,...
                    Lmk.Idp(i).wPatch,...
                    Lmk.Idp(i).Prj(cam).region,...
                    Lmk.Idp(i).Prj(cam).region.x0,...
                    .98,...
                    .89);



                pixFound = (Lmk.Idp(i).Prj(cam).sc > foundPixTh);

                if pixFound  % Pixel found

                    Lmk.Idp(i).Prj(cam).matched = 1;
                    Obs.y   = Lmk.Idp(i).Prj(cam).y;

                    % compute innovation statistics
                    Lmk.Idp(i) = uIdpInnovation(...
                        Lmk.Idp(i),...
                        cam,...
                        Obs.y,...
                        Obs.R);

                else  % Pixel not found

                    Lmk.Idp(i).Prj(cam).matched = 0;
                    Lmk.Idp(i).Prj(cam).y       = [];

                end



                pixGood = pixFound && (min(Lmk.Idp(i).Prj(cam).MD) < MDth);

                if  pixGood % ii. Good match

                    Lmk.Idp(i).Prj(cam).updated = 1;
                    Lmk.Idp(i).lost             = 0;

                    % Correct map
                    [Rob,Cam(cam)] = idpCorrection(...
                        Rob,...
                        Cam(cam),...
                        Lmk.Idp(i));

                    updates = updates + 1;

                else % iii. Bad or no match

                    Lmk.Idp(i).Prj(cam).updated = 0;
                    Lmk.Idp(i).lost = Lmk.Idp(i).lost + 1;

                end % of Good or bad matches

            end % of visible idps

        end % of cameras

        if Lmk.Idp(i).lost > lostIdpTh % if lost
            % Delete idp
            Lmk.Idp(i).used = false;
            liberateMap(Lmk.Idp(i).loc);

        else % Idp is not lost

            % Test for linearity:
            % this test is performed from camera 2 where the highest parallax
            % is observed. From Civera TRO 08
            Ld = xyzLinTest(Rob,Cam(2),Lmk.Idp(i));

            if Ld < 0.1 % value 0.1 is from Civera TRO 08

                % convert to single point
                np = getFree([Lmk.Pnt.used]);
                [Lmk.Idp(i),Lmk.Pnt(np)] = idp2pnt(...
                    Lmk.Idp(i),...
                    Lmk.Pnt(np),...
                    lostPntTh);
            end

        end



        if updates >= Lmk.simultIdp
            break
        end

    end % of idps

    % End of idp observations
    %------------------------------------------------------



    %------------------------------------------------------
    %
    % 1.h) Initialize new landmarks - idps
    %--------------------------------------

    % number of existing landmarks per region
    subImage = countLmks(subImage);

    % Maximum allowable initializations
    maxNewInit = getMaxInit;

    % idps to initialize per region
    subImage = numInit(subImage);
    regIdx   = find(subImage.numInit);
    regIdx   = randSort(regIdx);

    newInit = 0;

    for i = regIdx % at each region with not enough points:

        % i. look for new Harris points
        [pix,sc]   = harrisRegion(1,subImage,i,mrg,2,20);
        newInitReg = min(size(pix,2),maxNewInit-newInit);

        for j = 1:newInitReg

            % Define virtual idp
            Obs.y = pix(:,j); % observed pixel

            % Get an empty Idp
            idx = getFree([Lmk.Idp.used]);

            Lmk.Idp(idx)  = idpInit(...
                Lmk.Idp(idx),...
                Rob,...
                Cam(1),...
                Obs,...
                Rho,...
                patchSize);

            Lmk.Idp(idx) = projectIdp(Rob,Cam(2),Lmk.Idp(idx),Obs.R);

            if plotVray
                % define virtual ray vRay
                vRay.used = true;

                for cam = 1:2
                    % Idp elllipse
                    vRay.Prj(cam).y        = Lmk.Idp(idx).Prj(cam).y;
                    vRay.Prj(cam).u(:,1)   = Lmk.Idp(idx).Prj(cam).u;
                    vRay.Prj(cam).Z(:,:,1) = Lmk.Idp(idx).Prj(cam).Z;

                end


                % E_inf ellipse
                vRay.Prj(1).u = repmat(Obs.y,1,2);
                vRay.Prj(1).Z = repmat(Obs.R,[1,1,2]);

                [u,Hc1,Hc2,Hu] = transCamPhoto(Cam(1),Cam(2),Obs.y);
                Pc2 = Map.P(Cam(2).r,Cam(2).r); % Cam(2) covariance (orientation only)
                Hc2 = Hc2(:,Cam(2).or);
                U = Hc2*Pc2*Hc2' + Hu*Obs.R*Hu';
                Z = U + Obs.R;

                vRay.Prj(2).u(:,2)   = u;
                vRay.Prj(2).Z(:,:,2) = Z;


                [vRayHdle,vRay] = drawVray(vRayHdle,vRay,ns);

                switch video
                    case 0 % no video
                        drawnow;
                    case 1 % .avi
                        warning('Case 1 ''avi'' video deprecated. Not capturing.')
                    case 2 % JPEG sequence
                        fv = (1+plotVray)*f-1;
                        imgFrame(fig2,sprintf(seqFileImg,fv));
                        imgFrame(fig1,sprintf(seqFileMapTop,fv));
                        if videoSide
                            camorbit(ax1,0,-90)
                            imgFrame(fig1,sprintf(seqFileMapSide,fv));
                            camorbit(ax1,0,90)
                        end
                        if plotCalib
                            imgFrame(fig4,sprintf(seqFileCalib,fv));
                        end
                end

            end


            Lmk.Idp(idx).Prj(2).region = idp2par(...
                Lmk.Idp(idx),...
                ns,...
                2,...
                patchSize);



            [Lmk.Idp(idx).Prj(2).y,...
                Lmk.Idp(idx).Prj(2).sc,...
                Lmk.Idp(idx).Prj(2).cPatch] ...
                ...
                = patchScan(...
                2,...
                Lmk.Idp(idx).wPatch,...
                Lmk.Idp(idx).Prj(2).region,...
                Lmk.Idp(idx).Prj(2).region.x0,...
                .98,...
                .89);

            pixFound = (Lmk.Idp(idx).Prj(2).sc > .97);

            if pixFound

                % Match things
                Lmk.Idp(idx).Prj(2).matched = 1;
                Obs.y = Lmk.Idp(idx).Prj(2).y;

                % check consistency
                Lmk.Idp(idx) = uIdpInnovation(Lmk.Idp(idx),2,Obs.y,Obs.R);

                pixGood = (Lmk.Idp(idx).Prj(2).MD < MDth);

                if pixGood % found pix is inside search region -> update

                    Lmk.Idp(idx).Prj(2).updated = 1;

                    % correct map
                    [Rob,Cam(2)] = idpCorrection(...
                        Rob,...
                        Cam(2),...
                        Lmk.Idp(idx));

                end

            end

        end

        newInit = newInit + newInitReg;
        if newInit >= maxNewInit
            break  % Stop searching regions
        end

    end
    %
    %------------------------------------------------------

    %
    % END OF LANDMARK OBSERVATIONS
    %======================================================





    %======================================================
    %
    % 2. VISUALIZATIONS
    %===================

    projectAllLmks;

    % 1. Image plane figure
    dispImage   = displImage  (dispImage);
    dispProjIdp = dispProjIdps(dispProjIdp,ns);
    dispProjPnt = dispProjPnts(dispProjPnt,ns);

    % 2. Map figure
    dispMapIdp = dispMapIdps  (dispMapIdp,ns );
    dispMapPnt = dispMapPnts  (dispMapPnt,ns );
    dispEstRob = displayRobot (dispEstRob,Rob);
    dispEstCam = displayCamera(dispEstCam,Rob,Cam);

    if plotVray
        [vRayHdle,vRay] = drawVray(vRayHdle,vRay,ns);
        vRay.used = 0;
    end


    if plotUsed    % map's used space subgraph
        usedLm = displayUsed   (usedLm);
        maxLm  = displayMaxUsed(maxLm);
    end

    % 3. Calibration results
    if plotCalib        % Camera orientation error estimate
        cr   = Cam(2).r;
        q_rs = Map.X(cr);       % sensor quaternion
        Qrs  = Map.P(cr,cr);    % sensor noise
        [e_rc,ERCqrs]  = qrs2erc(q_rs); % camera Euler and Jacobian
        Erc  = ERCqrs*Qrs*ERCqrs';    % camera noise

        ec(:,f-fmin+2)  = rad2deg(e_rc);
        eec(:,f-fmin+2) = rad2deg(sqrt(diag(Erc)));

        fr = fmin-1:f;
        er = 1:f-fmin+2;
        for i=1:3
            set(calib(i),  'xdata',fr','ydata',ec(i,er)');
            set(cal_s(i),  'xdata',fr','ydata',c0(i,er)'+3*eec(i,er)');
            set(cal_s(i+3),'xdata',fr','ydata',c0(i,er)'-3*eec(i,er)');
        end
    end
    % 4. patches figure
    if plotPatches
        dispPatches(dispPatch);
    end

    % 5. video
    switch video
        case 0 % no video
            drawnow;
        case 1 % .avi
            warning('Case 1 ''avi'' video deprecated. Not capturing.')
        case 2 % JPEG sequence
            fv = (1+plotVray)*f;
            imgFrame(fig2,sprintf(seqFileImg,fv));
            imgFrame(fig1,sprintf(seqFileMapTop,fv));
            if videoSide
                camorbit(ax1,0,-90)
                imgFrame(fig1,sprintf(seqFileMapSide,fv));
                camorbit(ax1,0,90)
            end
            if plotCalib
                imgFrame(fig4,sprintf(seqFileCalib,fv));
            end
    end


    %
    % END OF VISUALIZATIONS
    %======================================================



    %======================================================
    %
    % 3. ROBOT MOTION
    %=================

    % get odo reading
    Odo.u = nOdo(f).u;
    Odo.u(3:5) = 0; % just 2D odometry
    un    = norm(Odo.u(1:WDIM));   % norm of step
    Udx   = un * dxNDR * [1 1 1]'; % translation noise variance
    Ude   = un * deNDR * [1 1 1]'; % rotation noise variance
    Ud    = [Udx;Ude];
    Odo.U = diag(Ud);              % noise covariances matrix

    % 3.a.  Estimated motion with noisy data
    Rob = robotMotion(Rob,Odo);

    % 3.b. Camera uncertainty
    Map.P(cr,cr) = Map.P(cr,cr) + 1e-67*eye(4);
    %
    % END OF ROBOT MOTION
    %======================================================


end
%
% END OF TIME EVOLUTION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% POST PROCESSING
%
%%%%%%%%%%%%%%%%%%

% Remove displayed idps
% set(dispMapIdp.elli,'vis','off')
% set(dispMapIdp.center,'vis','off')

% Coarse error evaluation of robot position
fprintf(...
    ' Robot uncertainty from P is about %4.2f x %4.2f x %4.2f mm\n\n',...
    1000*sqrt(Map.P(1,1)),...
    1000*sqrt(Map.P(2,2)),...
    1000*sqrt(Map.P(3,3)));

% Close video files
if video==1
    aviVideo1 = closeVideo(aviVideo1);
    aviVideo2 = closeVideo(aviVideo2);
    aviVideo3 = closeVideo(aviVideo3);
end
%
% ENF OF POST PROCESSING
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
