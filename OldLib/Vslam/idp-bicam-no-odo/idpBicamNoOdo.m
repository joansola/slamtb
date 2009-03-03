
% IDPBICAMNOODO  Inverse Depth SLAM with two cameras, no odometry.
%   Visual undelayed 3D-SLAM. This is the full algorithm with
%   data acquisition, image processing, tracking and SLAM.

% Copyright 2003-2008 Joan Sola @ LAAS-CNRS

clear ; clear global

% Experiment variables
experim     = 'cones';
expType     = 'bicam';
imType      = 'originals';

% Simulation options. On landmarks and map management
keepBack    = -100;   % Minimum depth in the map
reproject   = 1;    % Recompute jacobians at each lmk update
fmin        = 20;
fmax        = -1; % -1: take fmax = Nframes -1
randSeed    = -1; % Make this run repeatable. -1: true random % 1457

% Visualization options
mapView     = 'top';    % Map view {top,normal,side,view}
mapProj     = 'ort';    % Map projection type {orthographic,perspective}
plotVray    = 0;        % Show virtual idp
plotPatches = 0;        % Show landmark's patches figure
plotUsed    = 0;        % Show map usage
plotCalib   = 0;        % Show extrinsic self-calibration
video       = 0;        % 0: no video; 1: avi; 2: JPG images
videoSide   = 0;        % Capture side views of the map for video
warpMethod  = 3;        % 1: depth; 2: distance; 3: Jacobian



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% AUTOMATIC INITIALIZATIONS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% some nice things
format compact
home
fprintf('\n This is Coop-SLAM!\n\n\n');
if randSeed < 0
    clk = clock;
    randSeed = floor(100*clk(6)) % Make this run imprevisible but show seed
end
rand('state',randSeed);randn('state',randSeed);

% Root experiment directory
expdir   = [...
    '~/Documents/slam/Experiments/Micropix/' ...
    experim '/'];
imgdir   = [expdir 'images/' imType '/'];
figdir   = [expdir 'figures/'];
loadfile = [expdir experim '-' expType  '-' imType '.mat'];

% imgname{1} = 'Movie34%04d.png'; %  left image
% imgname{2} = 'Movie35%04d.png'; % right image
imgname{1} = 'Movie38%04d.png'; %  left image
imgname{2} = 'Movie39%04d.png'; % right image
% imgname{1} = 'Movie22%03d.png'; %  left image
% imgname{2} = 'Movie21%03d.png'; % right image

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

% Lanmarks identifiers
lmkId = 1;

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
    %   1.h  Initialize new idps in unpopulated image regions
    %

    %------------------------------------------------------
    %
    % 1.a) Take two photos
    %----------------------

    Image{1}  = oneShot([imgdir imgname{1}],f);
    Image{2}  = oneShot([imgdir imgname{2}],f);
    %     dispImage = displImage(dispImage);              % Display image
    
    if f-fmin == 1
        Lmk.maxInit = 1;
    end

    %
    %------------------------------------------------------




    %------------------------------------------------------
    %
    % 1.b) Project points onto images
    %---------------------------------

    for i = find([Lmk.Pnt.used])
        for rob = 1:2
            cam = rob;
            Lmk.Pnt(i) = projectPnt(...
                Rob(rob),...
                Cam(cam),...
                Lmk.Pnt(i),...
                Obs.R,...
                warpMethod);
        end
        Lmk.Pnt(i) = summarizePnt(Lmk.Pnt(i));
    end
    
    
%     dispProjIdp = dispProjIdps(dispProjIdp,ns);
%     dispProjPnt = dispProjPnts(dispProjPnt,ns);
%     dispImage = displImage(dispImage);              % Display image
%     drawnow


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
            
            % One robot per camera
            rob = cam;

            if Lmk.Pnt(i).Prj(cam).vis % visible points only

                % re-project point to get actual linearizations
                if reproject
                    Lmk.Pnt(i) = projectPnt(...
                        Rob(rob),...
                        Cam(cam),...
                        Lmk.Pnt(i),...
                        Obs.R,...
                        warpMethod);
                end

                % i. Search patch
                Lmk.Pnt(i).Prj(cam).region = pnt2par(...
                    Lmk.Pnt(i),...
                    ns,...
                    cam,...
                    patchSize); %  region to scan

                switch warpMethod
                    case 1
                        Lmk.Pnt(i).Prj(cam).wPatch = patchResize(...
                            Lmk.Pnt(i).sig,...
                            Lmk.Pnt(i).Prj(cam).sr^-1); % warp patch
                    case 2
                        Lmk.Pnt(i).Prj(cam).wPatch = patchResize(...
                            Lmk.Pnt(i).sig,...
                            Lmk.Pnt(i).Prj(cam).dr^-1); % warp patch
                    case 3
                        Lmk.Pnt(i).Prj(cam).wPatch = patchResize(...
                            Lmk.Pnt(i).sig,...
                            Lmk.Pnt(i).Prj(cam).UOui); % warp patch
                end
                
                [ Lmk.Pnt(i).Prj(cam).y,...
                    Lmk.Pnt(i).Prj(cam).sc,...
                    Lmk.Pnt(i).Prj(cam).cPatch] ...
                    ...
                    = patchScan(...
                    ...
                    cam,...
                    Lmk.Pnt(i).Prj(cam).wPatch,...
                    Lmk.Pnt(i).Prj(cam).region,...
                    Lmk.Pnt(i).Prj(cam).region.x0,...
                    .96,...
                    .95,...
                    pixDist);

                pixFound = (Lmk.Pnt(i).Prj(cam).sc > foundPntPixTh);

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
                    Lmk.Pnt(i).lost             = 0;

                    % move landmark
                    Lmk.Pnt(i) = moveLandmark(Lmk.Pnt(i));

                    % correct map
                    [Rob(rob),Cam(cam)] = lmkCorrection(...
                        Rob(rob),...
                        Cam(cam),...
                        Lmk.Pnt(i));

                    % Make Rob match the Map info
                    Rob(rob) = matchRobMap(Rob(rob));

                    updates = updates + 1;

                else  % iii. Bad or no match

                    Lmk.Pnt(i).Prj(cam).updated = 0;
                    Lmk.Pnt(i).lost = Lmk.Pnt(i).lost + 1;

                end % good or bad match

            end % visible point

        end % cameras
        
        % Make all Rob(i) match the Map info
        for rob=1:2
            Rob(rob) = matchRobMap(Rob(rob));
        end




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
        for rob = 1:length(Rob)
            cam = rob;
            Lmk.Idp(i) = projectIdp(...
                Rob(rob),...
                Cam(cam),...
                Lmk.Idp(i),...
                Obs.R,...
                warpMethod);
        end
        Lmk.Idp(i) = summarizeIdp(Lmk.Idp(i));
    end
    
%     dispProjIdp = dispProjIdps(dispProjIdp,ns);
%     dispProjPnt = dispProjPnts(dispProjPnt,ns);
%     dispImage = displImage(dispImage);              % Display image
%     drawnow



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

        for rob = 1:length(Rob) % for each camera

            cam = rob;

            % re-project idp to get actual linearizations
            if reproject
                Lmk.Idp(i) = projectIdp(...
                    Rob(rob),...
                    Cam(cam),...
                    Lmk.Idp(i),...
                    Obs.R,...
                    warpMethod);
            end


            if Lmk.Idp(i).Prj(cam).vis  % visible idp only

                % i. Search patch
                switch warpMethod
                    case 1
                        Lmk.Idp(i).Prj(cam).wPatch          = patchResize(...
                            Lmk.Idp(i).sig,...
                            Lmk.Idp(i).Prj(cam).sr^-1);
                    case 2
                        Lmk.Idp(i).Prj(cam).wPatch          = patchResize(...
                            Lmk.Idp(i).sig,...
                            Lmk.Idp(i).Prj(cam).dr^-1);
                    case 3
                        Lmk.Idp(i).Prj(cam).wPatch          = patchResize(...
                            Lmk.Idp(i).sig,...
                            Lmk.Idp(i).Prj(cam).UOui);
                end

                Lmk.Idp(i).Prj(cam).region = idp2par(...
                    Lmk.Idp(i),...
                    ns,...
                    cam,...
                    patchSize); % region to scan

                [ Lmk.Idp(i).Prj(cam).y,...
                    Lmk.Idp(i).Prj(cam).sc,...
                    Lmk.Idp(i).Prj(cam).cPatch] = patchScan(...
                    cam,...
                    Lmk.Idp(i).Prj(cam).wPatch,...
                    Lmk.Idp(i).Prj(cam).region,...
                    Lmk.Idp(i).Prj(cam).region.x0,...
                    .96,...
                    .95,...
                    pixDist);



                pixFound = (Lmk.Idp(i).Prj(cam).sc > foundIdpPixTh);

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
                    Lmk.Idp(i).Prj(cam).lost    = 0;

                    % Correct map
                    [Rob(rob),Cam(cam)] = idpCorrection(...
                        Rob(rob),...
                        Cam(cam),...
                        Lmk.Idp(i));
                    
                    % Make Rob match the Map info
                    Rob(rob) = matchRobMap(Rob(rob));

                    updates = updates + 1;

                else % iii. Bad or no match

                    Lmk.Idp(i).Prj(cam).updated = 0;
                    Lmk.Idp(i).Prj(cam).lost = Lmk.Idp(i).Prj(cam).lost + 1;

                end % of Good or bad matches

            end % of visible idp

        end % of cameras
        
        % Make all Rob(i) match the Map info
        for rob=1:2
            Rob(rob) = matchRobMap(Rob(rob));
        end

        
        Lmk.Idp(i) = summarizeIdp(Lmk.Idp(i));

        if Lmk.Idp(i).lost > lostIdpTh % if lost
            % Delete idp
            Lmk.Idp(i).used = false;
            liberateMap(Lmk.Idp(i).loc);

        else % Idp is not lost

            % Test for linearity:
            % this test is performed from camera 2 where the highest parallax
            % is observed. From Civera TRO 08
            Ld = xyzLinTest(Rob(2),Cam(2),Lmk.Idp(i));

            if Ld < LdTh % value 0.1 is from Civera TRO 08

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
        [pix,sc]   = harrisRegion(1,subImage,i,mrg,2,50,4); % 20
        newInitReg = min(size(pix,2),maxNewInit-newInit);

        for j = 1:newInitReg

            % Define virtual idp
            Obs.y = pix(:,j); % observed pixel

            % Get an empty Idp
            idx = getFree([Lmk.Idp.used]);

            Lmk.Idp(idx)  = idpInit(...
                lmkId,...
                Lmk.Idp(idx),...
                Rob(1),...
                Cam(1),...
                Obs,...
                Rho,...
                patchSize);
            
            lmkId = lmkId + 1;
          
            Lmk.Idp(idx) = projectIdp(Rob(2),Cam(2),Lmk.Idp(idx),Obs.R,warpMethod);
            
%             dispProjIdp = dispProjIdps(dispProjIdp,ns);
%             dispProjPnt = dispProjPnts(dispProjPnt,ns);
%             drawnow
% 
%             % 2. Map figure
%             dispMapIdp = dispMapIdps  (dispMapIdp,ns );
%             dispMapPnt = dispMapPnts  (dispMapPnt,ns );


            if plotVray
                % define virtual ray vRay
                vRay.used = true;

                for cam = 1:2
                    % Idp elllipse
                    vRay.Prj(cam).y        = Lmk.Idp(idx).Prj(cam).y;
                    vRay.Prj(cam).u(:,1)   = Lmk.Idp(idx).Prj(cam).u;
                    vRay.Prj(cam).Z(:,:,1) = Lmk.Idp(idx).Prj(cam).Z;

                end


                % E_1 ellipse
                vRay.Prj(1).u = repmat(Obs.y,1,2);
                vRay.Prj(1).Z = repmat(Obs.R,[1,1,2]);

                [u,Hc1,Hc2,Hu] = transCamPhoto(Cam(1),Cam(2),Obs.y);
                Pc2 = Map.P(Cam(2).r,Cam(2).r); % Cam(2) covariance (orientation only)
                Hc2 = Hc2(:,Cam(2).or);
                U = Hc2*Pc2*Hc2' + Hu*Obs.R*Hu';
                Z = U + Obs.R;

                % E_inf ellipse
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


            % i. Search patch
            switch warpMethod
                case 1
                    Lmk.Idp(idx).Prj(2).wPatch          = patchResize(...
                        Lmk.Idp(idx).sig,...
                        Lmk.Idp(idx).Prj(2).sr^-1);
                case 2
                    Lmk.Idp(idx).Prj(2).wPatch          = patchResize(...
                        Lmk.Idp(idx).sig,...
                        Lmk.Idp(idx).Prj(2).dr^-1);
                case 3
                    Lmk.Idp(idx).Prj(2).wPatch          = patchResize(...
                        Lmk.Idp(idx).sig,...
                        Lmk.Idp(idx).Prj(2).UOui);
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
                Lmk.Idp(idx).Prj(2).wPatch,...
                Lmk.Idp(idx).Prj(2).region,...
                Lmk.Idp(idx).Prj(2).region.x0,...
                1,...
                .95,...
                pixDist);

            %             pixFound = (Lmk.Idp(idx).Prj(2).sc > .97);
            pixFound = (Lmk.Idp(idx).Prj(2).sc > foundIdpPixTh);

            if pixFound

                % Match things
                Lmk.Idp(idx).Prj(2).matched = 1;
                Obs.y = Lmk.Idp(idx).Prj(2).y;

                % check consistency
                Lmk.Idp(idx) = uIdpInnovation(Lmk.Idp(idx),2,Obs.y,4*Obs.R);

                pixGood = (Lmk.Idp(idx).Prj(2).MD < MDth);

                if pixGood % found pix is inside search region -> update

                    Lmk.Idp(idx).Prj(2).updated = 1;

                    % correct map
                    [Rob(2),Cam(2)] = idpCorrection(...
                        Rob(2),...
                        Cam(2),...
                        Lmk.Idp(idx));

                    %                     dispProjIdp = dispProjIdps(dispProjIdp,ns);
                    %                     dispProjPnt = dispProjPnts(dispProjPnt,ns);
                    %
                    %                     % 2. Map figure
                    %                     dispMapIdp = dispMapIdps  (dispMapIdp,ns );
                    %                     dispMapPnt = dispMapPnts  (dispMapPnt,ns );

                    for rob=1:2
                        Rob(rob) = matchRobMap(Rob(rob));
                    end

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

    %     projectAllLmks;

    % 1. Image plane figure
    dispImage   = displImage  (dispImage);
    dispProjIdp = dispProjIdps(dispProjIdp,ns);
    dispProjPnt = dispProjPnts(dispProjPnt,ns);
    dispProjCam = dispPrjCam(dispProjCam,Rob,Cam);

    % 2. Map figure
    dispMapIdp = dispMapIdps  (dispMapIdp,ns );
    dispMapPnt = dispMapPnts  (dispMapPnt,ns );
    for i=1:2
        dispEstRob(i) = displayRobot (dispEstRob(i),Rob(i));
        dispEstCam(i) = displayCamera(dispEstCam(i),Rob(i),Cam(i));
        % trajectory
        traj = Rob(i).traj(:,fmin:f-1);
        set(dispTraj(i),'xdata',traj(1,:),'ydata',traj(2,:),'zdata',traj(3,:));
    end

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
    
%     [Rob(1).V Rob(2).V]
%     rad2deg(atan([Rob(1).V(3)/Rob(1).V(1) Rob(2).V(3)/Rob(2).V(1)]))
    
    


    %
    % END OF VISUALIZATIONS
    %======================================================



    %======================================================
    %
    % 3. ROBOT MOTION
    %=================

    % 3.a.  Estimated motion with noisy data
        % get odo reading
%     Odo.u = nOdo(f).u;
%     Odo.u(3:5) = 0; % just 2D odometry
%     un    = norm(Odo.u(1:WDIM));   % norm of step
%     Udx   = un * dxNDR * [1 1 1]'; % translation noise variance
%     Ude   = un * deNDR * [1 1 1]'; % rotation noise variance
%     Ud    = [Udx;Ude];
%     Odo.U = diag(Ud);              % noise covariances matrix

    % 3.a.  Estimated motion with noisy data
%     Rob(1) = robotMotion(Rob(1),Odo);

    
    
    for rob = 1:2
        % Perturbations depend ov V
        %         v         =  norm(Rob(rob).V(1:3)); % current robot's lin. speed
        %         vf        = noiseFactor(v,[.1 2 -.5]);       % noise amplitude factor
        %         w         =  norm(Rob(rob).V(4:6)); % current robot's ang. speed
        %         wf        = noiseFactor(w,[.1 2 -.5]);       % noise amplitude factor
        vf = 1;
        wf = 1;
        Pert(rob).Q = dt*diag([vf*vPert*[1 1 1] wf*wPert*[1 1 1]].^2);

%         fprintf('Rob %d:  lin %0.2f - fac %0.2f  |  ang %0.2f - fac %0.2f\n',rob,v,vf,w,wf);
        
        % Apply constant speed model
        Rob(rob) = robotInertial(Rob(rob),Pert(rob),dt);
  
        % Trajectory log
        Rob(rob).traj(:,f) = Rob(rob).X(1:3);
    end
%     fprintf('\n')

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
    ' Robot +/-3_sigma uncertainty from P is about %4.2f x %4.2f x %4.2f cm\n\n',...
    600*sqrt(Map.P(1,1)),...
    600*sqrt(Map.P(2,2)),...
    600*sqrt(Map.P(3,3)));

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
