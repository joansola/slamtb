% FISSLAMFULL  Federated Information Sharing SLAM with real data
%   Visual undelayed 3D-SLAM. This is the full algorithm with
%   data acquisition, image processing, tracking and SLAM.

% Copyright 2003-2006 Joan Sola @ LAAS-CNRS

%% START
% clear all variables, globals and persistents
clear ; clear global; clear harris_strongest displayMaxUsed

% Experiment variables
site        = 'Micropix'
experim     = 'cones';
imType      = 'originals';

% Simulation options. On landmarks and map management
keepBack    = -15;     % Minimum depth in the map
reproject   = 1;       % Recompute jacobians at each lmk update
regions     = 7;       % grid of regions
fmin        = 10;
fmax        = 911;      % -1: take fmax = Nframes -1
randSeed    = 4;      % Make this run repeatable. -1: true random

% Visualization options
mapView     = 'top';   % Map view {top,normal,side,view}
mapProj     = 'ortho'; % Map projection type {orthographic,perspective}
equalizeIm  = 0;       % Image gray equalization
plotPatches = 0;       % Show landmark's patches figure
plotUsed    = 0;       % Show map usage
video       = 0;       % 0: no video; 1: avi; 2: save JPG images


%%
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
expdir   = ['~/Documents/slam/Experiments/' site '/' experim '/'];
% expdir   = ['~/Desktop/' site '/' experim '/'];
imgdir   = [expdir 'images/' imType '/'];
figdir   = [expdir 'figures/'];
loadfile = [expdir experim '-mono-' imType '.mat'];

switch experim
    case 'test14'
        imgname = 'image.%03d.s.png';
    case 'sri01'
        imgname = 'images-%05d-L.bmp';
    case 'mv01'
        imgname = 'images-%05d.png';        
    case 'cones'
        imgname = 'Movie38%04d.png';
    otherwise
        imgname = 'image.%03d.g';
end

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
    
%% HELP
    %======================================================
    %
    % 1. LANDMARK OBSERVATIONS
    %==========================
    %
    % The sequence is:
    %   1.a  Take one photo
    %   1.b  Project points
    %   1.c  Select Np points with big projected ellipse
    %   1.d  Observe Np points
    %   1.e  Project rays and delete non visible ones
    %   1.f  Get Harris points in unpopulated image regions and
    %         initialize new rays
    %   1.g  Select Nr rays with big projected ellipses
    %   1.h  Observe Nr rays
    %

    
%%
    %------------------------------------------------------
    %
    % 1.a) Take one photo
    %---------------------

    Image{1} = oneShot([imgdir imgname],f,equalizeIm);
    %
    %------------------------------------------------------



%%
    %------------------------------------------------------
    %
    % 1.b) Project points
    %---------------------

    for i = find([Lmk.Pnt.used])
        Lmk.Pnt(i) = projectPnt(Rob,Cam,Lmk.Pnt(i));
    end

    % delete points behind camera
    backPnts = [Lmk.Pnt.used] & ([Lmk.Pnt.s] < keepBack);
    for i = find(backPnts)
        Lmk.Pnt(i).used = false;
        liberateMap(Lmk.Pnt(i).loc);
    end
    %
    %------------------------------------------------------



%%
    %------------------------------------------------------
    %
    % 1.c) Select points with biggest dU to correct
    %-----------------------------------------------

    % visible points
    visPnts = [Lmk.Pnt.used] & [Lmk.Pnt.vis];

    % sort dU
    [bigdU,bigVisPnts] = sBiggest(...
        Lmk.Pnt(visPnts),...
        'dU');

    % indices to biggest-dU visible points
    visPnts = find(visPnts);
    bigPnts = visPnts(bigVisPnts);
    %
    %------------------------------------------------------



%%
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

        % re-project point to get actual linearizations
        if reproject
            Lmk.Pnt(i) = projectPnt(Rob,Cam,Lmk.Pnt(i));
        end

        % i. Search patch
        Lmk.Pnt(i).wPatch = patchResize(...
            Lmk.Pnt(i).sig,...
            Lmk.Pnt(i).sr^-1); % warp patch

        Lmk.Pnt(i).region = pnt2par(...
            Lmk.Pnt(i),...
            ns,...
            1,...
            patchSize); %  region to scan

        [pix,Lmk.Pnt(i).sc,Lmk.Pnt(i).cPatch] = patchScan(...
            1,...
            Lmk.Pnt(i).wPatch,...
            Lmk.Pnt(i).region,...
            Lmk.Pnt(i).region.x0,...
            .98,...
            .89);

        pixFound = (Lmk.Pnt(i).sc > foundPixTh);
        if pixFound % Pixel found
            
            Lmk.Pnt(i).matched = 1;
            Lmk.Pnt(i).y       = pix;
            
            Lmk.Pnt(i)         = uPntInnovation(...
                Lmk.Pnt(i),...
                pix,...
                Obs.R);
            
        else  % Pixel not found
            Lmk.Pnt(i).matched = 0;
            Lmk.Pnt(i).y       = [];
        end

        pixGood = pixFound && (Lmk.Pnt(i).MD < MDth);
        
        % ii. Good match
        if pixGood 
            Lmk.Pnt(i).updated = 1;
            Lmk.Pnt(i).lost    = 0;

            % move landmark
            Lmk.Pnt(i) = moveLandmark(Lmk.Pnt(i));

            % correct map
            Rob = lmkCorrection(Rob,Lmk.Pnt(i));
            Rob.V = Map.X(8:13);

            updates = updates + 1;
            if updates >= Lmk.simultPnt
                break
            end

           
        else  % iii. Bad or no match
            
            Lmk.Pnt(i).updated = 0;
            Lmk.Pnt(i).lost = Lmk.Pnt(i).lost + 1;
            
            if Lmk.Pnt(i).lost > lostPntTh
                
                % delete landmark
                Lmk.Pnt(i).used = false;
                liberateMap(Lmk.Pnt(i).loc);
                
            else
                
                % move landmark
                Lmk.Pnt(i) = moveLandmark(Lmk.Pnt(i));

            end
        end
    end

    % end of point observations
    %------------------------------------------------------



%%
    %------------------------------------------------------
    %
    % 1.e) Project rays
    %-------------------

    for i = find([Lmk.Ray.used])
        Lmk.Ray(i) = projectRay(Rob,Cam,Lmk.Ray(i));
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



%%
    %------------------------------------------------------
    %
    % 1.f) Get new points in unpopulated image regions
    %--------------------------------------------------

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
        [pix,sc]   = harrisRegion(1,subImage,i,mrg,2,20);
        newInitReg = min(size(pix,2),maxNewInit-newInit);
        
        % ii. Initialize rays
        for j = 1:newInitReg % for each point in region to initialize
            idx   = getFree([Lmk.Ray.used]); % index to Ray structure array
            Obs.y = pix(:,j); % observed pixel

            % create ray template
            Lmk.Ray(idx) = newRay(...
                Lmk.Ray(idx),...
                1,...
                pix(:,j),...
                patchSize,...
                sMin,sMax,...
                alpha,beta,gamma,tau,...
                lostRayTh,...
                scLength);

            % initialize ray
            Lmk.Ray(idx) = rayInit(...
                Rob,...
                Cam,...
                Obs,...
                Lmk.Ray(idx));
        end
        
        newInit = newInit + newInitReg;
        if newInit >= maxNewInit 
            break  % Stop searching regions
        end
    
    end
    %
    %------------------------------------------------------



%%
    %------------------------------------------------------
    %
    % 1.g) Select rays with biggest dU to correct
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




%%
    %------------------------------------------------------
    %
    % 1.h) Observe rays
    %
    % Por each ray to observe, the sequence is
    %
    %   i. Search patch
    %  ii. Good match
    % iii. Bad or no match

    updates = 0; % Updated rays counter
    for i = bigRays
        
        % re-project ray to get actual linearizations
        if reproject 
            Lmk.Ray(i) = projectRay(Rob,Cam,Lmk.Ray(i));
        end

        % i. Search patch
        Lmk.Ray(i).wPatch = patchResize(...
            Lmk.Ray(i).sig,...
            Lmk.Ray(i).sr^-1);

        Lmk.Ray(i).region = ray2par(Lmk.Ray(i),...
            ns,...
            1,...
            patchSize); % region to scan

        [pix,Lmk.Ray(i).sc,Lmk.Ray(i).cPatch] = patchScan(...
            1,...
            Lmk.Ray(i).wPatch,...
            Lmk.Ray(i).region,...
            Lmk.Ray(i).region.x0,...
            .98,...
            .89);

        pixFound = (Lmk.Ray(i).sc > foundPixTh);
        if pixFound  % Pixel found

            Lmk.Ray(i).matched = 1;
            Lmk.Ray(i).y       = pix;

            % compute innovation statistics
            Lmk.Ray(i)         = uRayInnovation(...
                Lmk.Ray(i),...
                pix,...
                Obs.R);

        else  % Pixel not found
            
            Lmk.Ray(i).matched = 0;
            Lmk.Ray(i).y       = [];
        
        end

        pixGood = pixFound && (min(Lmk.Ray(i).MD) < MDth);

        if  pixGood % ii. Good match

            Lmk.Ray(i).updated = 1;
            Lmk.Ray(i).lost    = 0;

            % re-balance weights
            Lmk.Ray(i) = balWeight(Lmk.Ray(i));

            % update weights
            Lmk.Ray(i) = updateWeight(Lmk.Ray(i));

            % prune low weighted members from ray
            Lmk.Ray(i) = pruneRay(Lmk.Ray(i));

            % prune twin members
            Lmk.Ray(i) = pruneTwinPoints(Lmk.Ray(i));

            % remove pruned ray members from map
            liberateMap(Lmk.Ray(i).pruned);

            if Lmk.Ray(i).n == 1 % Is single member

                % convert to single point
                np = getFree([Lmk.Pnt.used]);
                [Lmk.Ray(i),Lmk.Pnt(np)] = ray2pnt(...
                    Lmk.Ray(i),...
                    Lmk.Pnt(np),...
                    lostPntTh);

                % correct map
                Rob = lmkCorrection(Rob,Lmk.Pnt(np));
                Rob.V = Map.X(8:13);

            else   % Is still a ray
                % FIS-correct map
                Obs.y = pix;
                Rob = FISUpdate(Rob,Lmk.Ray(i),Obs);
                Rob.V = Map.X(8:13);
            end

            updates = updates + 1;
            if updates >= Lmk.simultRay
                break
            end

        else % iii. Bad or no match

            Lmk.Ray(i).updated = 0;
            Lmk.Ray(i).lost = Lmk.Ray(i).lost + 1;

            if Lmk.Ray(i).lost > lostRayTh % if lost
                % Delete ray
                Lmk.Ray(i).used = false;
                liberateMap(Lmk.Ray(i).loc(1:Lmk.Ray(i).n));
            end
        end
    end

    % End of ray observations
    %------------------------------------------------------

    %
    % END OF LANDMARK OBSERVATIONS
    %======================================================



%%
    %======================================================
    %
    % 2. VISUALIZATIONS
    %===================

    % 1. Image plane figure
    displImage;                         % Display image
    dispObsRays                         % display observed landmarks
    dispObsPnts
    dispProjRays;                       % display projected landmarks
    dispProjPnts;
    
    % 2. Map figure
    dispMapRays                         % 3D ellipsoids
    dispMapPnts
    dispEstRob = displayRobot(dispEstRob,Rob);      % Robot
    dispEstCam = displayCamera(dispEstCam,Rob,Cam); % Camera 
    % trajectory
    traj = Rob.traj(:,fmin:f-1);
    set(dispTraj,'xdata',traj(1,:),'ydata',traj(2,:),'zdata',traj(3,:),'color','g');
      
    if plotUsed                         % map's used space subgraph
        usedLm = displayUsed(usedLm);
        maxLm = displayMaxUsed(maxLm);
    end

    % 3. patches figure
    if plotPatches
        dispPatches(dispPatch);
    end

    % 4. video
    switch video
        case 0 % no video
            drawnow;
        case 1 % .avi
            aviVideoMapTop = videoFrame(aviVideoMapTop,fig1);
            aviVideoImg = videoFrame(aviVideoImg,fig2,ax21);
        case 2 % JPEG sequence
            imgFrame(fig2,sprintf(seqFileImg,f),ax21);
            imgFrame(fig1,sprintf(seqFileMapTop,f));
            camorbit(ax1,0,-90)
            imgFrame(fig1,sprintf(seqFileMapSide,f));
            camorbit(ax1,0,90)
    end

    %
    % END OF VISUALIZATIONS
    %======================================================



%%
    %======================================================
    %
    % 3. ROBOT MOTION
    %=================
    if f == 914 % This tries to overcome the jump in the SRI series. Remove for other experiments!!!
        edt = 17*dt;
    else
        edt = dt;
    end

    % 2.a.  Estimated motion with noisy data
    Rob = robotInertial(Rob,Pert,edt);
    
    % Trajectory log
    Rob.traj(:,f) = Rob.X(1:3);
    
    %
    % END OF ROBOT MOTION
    %======================================================

    
    %======================================================
    %
    % Extra. FIGURES SAVING
    %=======================
    
    %     if f == bfloor(f,5) | f == Nframes
    %         ttext = sprintf('%03d',f);
    %         filemap = [figdir 'map-' ttext '.png'];
    %         fileimg = [figdir 'img-' ttext '.png'];
    %         img = getframe(ax21);
    %         map = getframe(ax1);
    %         imwrite(map.cdata,filemap);
    %         imwrite(img.cdata,fileimg);
    %     end

end
%
% END OF TIME EVOLUTION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% POST PROCESSING
%
%%%%%%%%%%%%%%%%%%

% Remove displayed rays
set(dispMapRay.elli,'vis','off')
set(dispMapRay.center,'vis','off')

% Coarse error evaluation of robot position
fprintf(...
    ' Robot 3-sigma uncertainty from P is about %4.2f x %4.2f x %4.2f mm\n\n',...
    3000*sqrt(Map.P(1,1)),...
    3000*sqrt(Map.P(2,2)),...
    3000*sqrt(Map.P(3,3)));

% Close video files
if video == 1
    aviVideo1 = closeVideo(aviVideo1);
    aviVideo2 = closeVideo(aviVideo2);
end
%
% ENF OF POST PROCESSING
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
