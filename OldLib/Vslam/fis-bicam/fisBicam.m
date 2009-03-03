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
keepBack    = -15;   % Minimum depth in the map
reproject   = 1;    % Recompute jacobians at each lmk update
fmin        = 20;
fmax        = 80; % -1: take fmax = Nframes -1
randSeed    = -1; % Make this run repeatable. -1: true random

% Visualization options
mapView     = 'top';    % Map view {top,normal,side,view}
mapProj     = 'ortho';  % Map projection type {orthographic,perspective}
equalizeIm  = 0;        % Image gray equalization
plotVray    = 0;        % Show virtual ray
plotPatches = 0;        % Show landmark's patches figure
plotUsed    = 0;        % Show map usage
plotCalib   = 0;        % Show extrinsic self-calibration
video       = 0;        % 0: no video; 1: avi; 2: JPG images



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

% Root experiment directory
expdir   = [...
    '~/Documents/slam/Experiments/Dala/' ...
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
lastUsedRays   = zeros(1,Lmk.maxRay); % last frame's used rays

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
    %   1.e  Project rays and delete non visible ones
    %   1.f  Select Nr rays with big projected ellipses
    %   1.g  Observe Nr rays
    %   1.h  Get Harris points in unpopulated image regions and
    %         initialize new rays
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
                    1,...
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
    % 1.e) Project rays
    %-------------------

    for i = find([Lmk.Ray.used])
        for cam = 1:length(Cam)
            Lmk.Ray(i) = projectRay(...
                Rob,...
                Cam(cam),...
                Lmk.Ray(i),...
                Obs.R);
        end
        Lmk.Ray(i) = summarizeRay(Lmk.Ray(i));
    end


    % Delete non visible rays
    nonVisRays = lastUsedRays & ~[Lmk.Ray.vis0];
    for i = find(nonVisRays)
        Lmk.Ray(i).used = false;
        loc = Lmk.Ray(i).loc(1:Lmk.Ray(i).n);
        liberateMap(loc);
    end

    % Remember previous rays' indices
    lastUsedRays = [Lmk.Ray.used];
    %
    %------------------------------------------------------




    %------------------------------------------------------
    %
    % 1.f) Select rays with biggest dU to correct
    %---------------------------------------------

    % visible rays (without those just initialized)
    lastVisRays = lastUsedRays & [Lmk.Ray.vis0];

    % sort dUmax
    [bigdU,bigVisRays] = sBiggest(...
        Lmk.Ray(lastVisRays),...
        'dUmax');

    % indices to biggest-dU visible rays
    bigRays = find(lastVisRays);
    bigRays = bigRays(bigVisRays);
    %
    %------------------------------------------------------





    %------------------------------------------------------
    %
    % 1.g) Observe rays
    %
    % Por each ray to observe, the sequence is
    %
    %   i. Search patch
    %  ii. Good match
    % iii. Bad or no match

    updates = 0; % Updated rays counter
    for i = bigRays

        for cam = 1:length(Cam) % for each camera


            % re-project ray to get actual linearizations
            if reproject
                Lmk.Ray(i) = projectRay(...
                    Rob,...
                    Cam(cam),...
                    Lmk.Ray(i),...
                    Obs.R);
            end


            if Lmk.Ray(i).Prj(cam).vis0  % visible rays only

                % i. Search patch
                Lmk.Ray(i).wPatch          = patchResize(...
                    Lmk.Ray(i).sig,...
                    Lmk.Ray(i).Prj(cam).sr^-1);

                Lmk.Ray(i).Prj(cam).region = ray2par(...
                    Lmk.Ray(i),...
                    cam,...
                    ns,...
                    patchSize); % region to scan

                [ Lmk.Ray(i).Prj(cam).y,...
                    Lmk.Ray(i).Prj(cam).sc,...
                    Lmk.Ray(i).Prj(cam).cPatch] = patchScan(...
                    cam,...
                    Lmk.Ray(i).wPatch,...
                    Lmk.Ray(i).Prj(cam).region,...
                    Lmk.Ray(i).Prj(cam).region.x0,...
                    1,...
                    .89);



                pixFound = (Lmk.Ray(i).Prj(cam).sc > foundPixTh);

                if pixFound  % Pixel found

                    Lmk.Ray(i).Prj(cam).matched = 1;
                    Obs.y   = Lmk.Ray(i).Prj(cam).y;

                    % compute innovation statistics
                    Lmk.Ray(i) = uRayInnovation(...
                        Lmk.Ray(i),...
                        cam,...
                        Obs.y,...
                        Obs.R);

                else  % Pixel not found

                    Lmk.Ray(i).Prj(cam).matched = 0;
                    Lmk.Ray(i).Prj(cam).y       = [];

                end



                pixGood = pixFound && (min(Lmk.Ray(i).Prj(cam).MD) < MDth);

                if  pixGood % ii. Good match

                    Lmk.Ray(i).Prj(cam).updated = 1;
                    Lmk.Ray(i).lost             = 0;

                    Lmk.Ray(i) = balWeight(Lmk.Ray(i)); % re-balance weights
                    Lmk.Ray(i) = updateWeight(Lmk.Ray(i),cam); % update weights
                    Lmk.Ray(i) = pruneRay(Lmk.Ray(i)); % prune ray members
                    Lmk.Ray(i) = pruneTwinPoints(Lmk.Ray(i)); % prune twin members

                    liberateMap(Lmk.Ray(i).pruned); % remove pruned ray members from map

                    % FIS-correct map
                    [Rob,Cam(cam)] = FISUpdate(Rob,Cam(cam),Lmk.Ray(i),Obs);

                    updates = updates + 1;

                else % iii. Bad or no match

                    Lmk.Ray(i).Prj(cam).updated = 0;
                    Lmk.Ray(i).lost = Lmk.Ray(i).lost + 1;

                end % of Good or bad matches

            end % of visible rays

        end % of cameras


        if Lmk.Ray(i).n == 1 % Is single member

            % convert to single point
            np = getFree([Lmk.Pnt.used]);
            [Lmk.Ray(i),Lmk.Pnt(np)] = ray2pnt(...
                Lmk.Ray(i),...
                Lmk.Pnt(np),...
                lostPntTh);
        end


        if Lmk.Ray(i).lost > lostRayTh % if lost
            % Delete ray
            Lmk.Ray(i).used = false;
            liberateMap(Lmk.Ray(i).loc(1:Lmk.Ray(i).n));
        end


        if updates >= Lmk.simultRay
            break
        end

    end % of rays

    % End of ray observations
    %------------------------------------------------------



    %------------------------------------------------------
    %
    % 1.h) Initialize new landmarks - points or rays 
    %------------------------------------------------

    % number of existing landmarks per region
    subImage = countLmks(subImage);

    % Maximum allowable initializations
    maxNewInit = getMaxInit;

    % rays to initialize per region
    subImage = numInit(subImage);
    regIdx   = find(subImage.numInit);
    regIdx   = randSort(regIdx);

    newInit = 0;

    for i = regIdx % at each region with not enough points:

        % i. look for new Harris points
        [pix,sc]   = harrisRegion(1,subImage,i,mrg,2,10);
        newInitReg = min(size(pix,2),maxNewInit-newInit);

        for j = 1:newInitReg

            % Define virtual ray
            Obs.y = pix(:,j); % observed pixel
            vRay  = vRayInit(...
                Cam,...
                Obs,...
                sMin,1e4,...
                alpha,...
                patchSize);

            vRay.Prj(2).region = ray2par(...
                vRay,...
                2,...
                ns,...
                patchSize);

            [ vRay.Prj(2).y,...
                vRay.Prj(2).sc,...
                vRay.Prj(2).cPatch] ...
                ...
                = patchScan(...
                2,...
                vRay.wPatch,...
                vRay.Prj(2).region,...
                vRay.Prj(2).region.x0,...
                1,...
                .89);

            if plotVray
                [vRayHdle,vRay] = drawVray(vRayHdle,vRay,ns);
%                 pause(1)

                % video
                switch video
                    case 0 % no video
                        drawnow;
                    case 1 % .avi
%                         aviVideo1 = videoFrame(aviVideo1,fig1);
%                         camorbit(0,-90);
%                         aviVideo2 = videoFrame(aviVideo2,fig1);
%                         camorbit(0,90);
                        aviVideo3 = videoFrame(aviVideo3,fig2);
                    case 2 % save images
                        imgFrame(fig2,sprintf(seqFileImg,f));
                        imgFrame(fig1,sprintf(seqFileMapTop,f));
                        camorbit(ax1,0,-90)
                        imgFrame(fig1,sprintf(seqFileMapSide,f));
                        camorbit(ax1,0,90)

                end
            end

            pixFound = (vRay.Prj(2).sc > foundPixTh);
%             pixFound = (vRay.Prj(2).sc > .95);


            if pixFound

                % Match things
                vRay.Prj(2).matched = 1;

                % Check distance to epipolar
                u1      = vRay.Prj(2).u(:,1); % nearby member on cam 2
                u2      = vRay.Prj(2).u(:,2); % vanishing point on cam 2
                y2      = vRay.Prj(2).y;      % measured pix on cam 2
                a       = y2 - u1;
                b       = u2 - u1;
                na      = norm(a);
                cosa    = a'*b/na/norm(b);
                sina    = sqrt(1-cosa^2);
                d       = na*sina; % this is the distance

                % 1sigma ellipse of innovations
                Up      = vRay.Prj(2).Up(:,:,2);
                sigmapx  = sqrt(Up(1,1));
                sigmapy  = sqrt(Up(2,2));
                Zc      = vRay.Prj(2).Uc(:,:,2) + Obs.R;
                sigmacx  = sqrt(Zc(1,1));
                sigmacy  = sqrt(Zc(2,2));
                Z2      = vRay.Prj(2).Z(:,:,2);
                sigma2x  = sqrt(Z2(1,1));
                sigma2y  = sqrt(Z2(2,2));

                pixGood = (d < ns*sigma2y);

                if pixGood % found pix is inside search region

                    % Critical pixel
                    yCrit = u2 - [4*(sigmapx+sigmacx);0]; % 4sigma criterion

                    % Check for depth observability
                    depth3d = (y2(1) < yCrit(1)); 

                    if depth3d
                        % Full 3D initialization

                        % get 3d point - robot frame
                        o1 = Cam(1).X(1:WDIM);
                        o2 = Cam(2).X(1:WDIM);
                        v1 = invCamPhoto(Cam(1),vRay.Prj(1).y,1) - o1;
                        v2 = invCamPhoto(Cam(2),vRay.Prj(2).y,1) - o2;
                        [pc,p1,p2] = inter3D(o1,v1,o2,v2);

                        % go to camera frame
                        p3d = toFrame(Cam(1),p1);

                        % get depth
                        Dpt.s = p3d(3);
                        Dpt.S = (alpha*Dpt.s)^2;

                        % Initialize point at depth s with
                        % observation of camera 1
                        Obs.y      = vRay.Prj(1).y;
                        k          = getFree([Lmk.Pnt.used]);
                        Lmk.Pnt(k) = pntInit(...
                            Lmk.Pnt(k),...
                            Rob,...
                            Cam(1),...
                            Obs,...
                            Dpt,...
                            patchSize,...
                            lostPntTh);

                        % Project onto camera 2
                        Lmk.Pnt(k) = projectPnt(...
                            Rob,...
                            Cam(2),...
                            Lmk.Pnt(k),...
                            Obs.R);

                        % Complete point statistics and flags
                        Obs.y      = vRay.Prj(2).y;
                        Lmk.Pnt(k) = uPntInnovation(...
                            Lmk.Pnt(k),...
                            2,...
                            Obs.y,...
                            Obs.R);
                        Lmk.Pnt(k).Prj(2).y       = Obs.y;
                        Lmk.Pnt(k).Prj(2).matched = 1;
                        Lmk.Pnt(k).Prj(2).updated = 1;

                        % correct map
                        [Rob,Cam(2)] = lmkCorrection(...
                            Rob,...
                            Cam(2),...
                            Lmk.Pnt(k));


                    else % Initialize ray beyond critical depth

                        % Get critical point - robot frame
                        o1 = Cam(1).X(1:WDIM);
                        o2 = Cam(2).X(1:WDIM);
                        v1 = invCamPhoto(Cam(1),vRay.Prj(1).y,1) - o1;
                        v2 = invCamPhoto(Cam(2),yCrit,1) - o2;
                        [pc,p1,p2] = inter3D(...
                            o1,v1,o2,v2);    % 3D critical point

                        % go to camera 1 frame
                        pCrit = toFrame(Cam(1),p1);

                        % critical depth
                        sCrit = pCrit(3);

                        % Ray initialization beyond critical point
                        r          = getFree([Lmk.Ray.used]);
                        Lmk.Ray(r) = rayInit(...
                            Lmk.Ray(r),...
                            Rob,...
                            Cam(1),...
                            Obs,...
                            sCrit,sMax,...
                            alpha,beta,gamma,tau,...
                            patchSize,...
                            lostRayTh);

                        % Observation on camera 2
                        Obs.y               = vRay.Prj(2).y;
                        Lmk.Ray(r).Prj(2).y = Obs.y;
                        Lmk.Ray(r).Prj(2).matched = 1;
                        Lmk.Ray(r).Prj(2).updated = 1;

                        % Project onto camera 2
                        Lmk.Ray(r) = projectRay(...
                            Rob,...
                            Cam(2),...
                            Lmk.Ray(r),...
                            Obs.R);

                        % Complete ray statistics
                        Lmk.Ray(r) = uRayInnovation(...
                            Lmk.Ray(r),...
                            2,...
                            Obs.y,...
                            Obs.R);

                        % Weight updating and pruning
                        Lmk.Ray(r) = updateWeight(Lmk.Ray(r),2);
                        Lmk.Ray(r) = pruneRay(Lmk.Ray(r));
                        Lmk.Ray(r) = pruneTwinPoints(Lmk.Ray(r));

                        liberateMap(Lmk.Ray(r).pruned);

                        % correct map
                        [Rob,Cam(2)] = FISUpdate(...
                            Rob,...
                            Cam(2),...
                            Lmk.Ray(r),...
                            Obs);

                    end % of depth3d

                else
                    % Do nothing
                end

            else
                % Do nothing
            end

        end

        newInit = newInit + newInitReg;
        if newInit >= maxNewInit
            break  % Stop searching regions
        end

        %         break; % search only one region
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
    dispProjRay = dispProjRays(dispProjRay,ns);
    dispProjPnt = dispProjPnts(dispProjPnt,ns);
    if plotVray
        [vRayHdle,vRay] = drawVray(vRayHdle,vRay,ns);
    end
    
    % 2. Map figure
    dispMapRay = dispMapRays  (dispMapRay,ns );
    dispMapPnt = dispMapPnts  (dispMapPnt,ns );
    dispEstRob = displayRobot (dispEstRob,Rob);
    dispEstCam = displayCamera(dispEstCam,Rob,Cam);
    

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
        
        fr = fmin:f;
        er = 1:f-fmin+1;
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
            aviVideo1 = videoFrame(aviVideo1,fig1);
            camorbit(0,-90);
            aviVideo2 = videoFrame(aviVideo2,fig1);
            camorbit(0,90);
            aviVideo3 = videoFrame(aviVideo3,fig2);
        case 2 % JPEG sequence
            imgFrame(fig2,sprintf(seqFileImg,f));
            imgFrame(fig1,sprintf(seqFileMapTop,f));
            camorbit(ax1,0,-90)
            imgFrame(fig1,sprintf(seqFileMapSide,f));
            camorbit(ax1,0,90)
            if plotCalib
                imgFrame(fig4,sprintf(seqFileCalib,f));
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

% Remove displayed rays
% set(dispMapRay.elli,'vis','off')
% set(dispMapRay.center,'vis','off')

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
