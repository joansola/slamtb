% FISSLAMFULL  Federated Information Sharing SLAM with real data
%   Visual undelayed 3D-SLAM. This is the full algorithm with
%   data acquisition, image processing, tracking and SLAM.

% Copyright 2003-2006 Joan Sola @ LAAS-CNRS

%% START
% clear all variables
clear ; clear global; clear harris_strongest displayMaxUsed

% Experiment variables
site        = 'SIMU'
experim     = 'sparse01';

% Simulation options. On landmarks and map management
keepBack    = -50;     % Minimum depth in the map
reproject   = 0;       % Recompute jacobians at each lmk update
fmin        = 1;
fmax        = 100;      % -1: take fmax = Nframes -1
randSeed    = -1;      % Make this run repeatable. -1: true random
%1161
% Visualization options
mapView     = 'top';   % Map view {top,normal,side,view}
mapProj     = 'ortho'; % Map projection type {orthographic,perspective}
plotUsed    = 0;       % Show map usage
video       = 0;       % 0: no video; 1: avi; 2: save JPG images
con         = 0;       % consistency test



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
figdir   = [expdir 'figures/'];
loadfile = [expdir experim '-mono.mat'];

% Read real data files -> set {Nframes, nOdo, camera}
load(loadfile);

% Initialize simulation variables
if fmax < fmin, fmax = fmin; end
initConst;
% overwrite alpha and beta:
% alpha = 0.15;
% beta  = 1.5;
initRobot;
initCamera;
initWorld;
initLmks;
initMap;
initImage;
lastUsedRays   = zeros(1,Lmk.maxRay); % last frame's used rays

% Initialize visualizations
initMapFig;
initImageFig;
initVideo;

% Data logging
N   = size(World,2); % Nbr fo landmarks in world
MR  = zeros(fmax,1); % Mahalanobis ratio of robot position
[ESx,ESy,ESz] = deal(zeros(fmax,N)); % error to sigma ratio of landmarks

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

lmkId = 1; % first lmk to initialize
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
    %   1.f  Initialize new rays
    %   1.g  Select Nr rays with big projected ellipses
    %   1.h  Observe Nr rays
    %

    
%%
    %------------------------------------------------------
    %
    % 1.a) Take one photo
    %---------------------

    Image = simShot(RobSim,Cam,World);
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
        pix = Image(:,Lmk.Pnt(i).id);

        Lmk.Pnt(i).matched = 1;
        Lmk.Pnt(i).y       = pix;

        Lmk.Pnt(i)         = uPntInnovation(...
            Lmk.Pnt(i),...
            pix,...
            Obs.R);


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
    % 1.f) Initialize new rays
    %--------------------------------------------------

    % lmks to initialize
    for id = lmkId:min(lmkId + maxInit - 1,size(World,2));

        % i. look for new Harris points
        pix   = detectFeature(Image,id);

        % ii. Initialize rays
        Obs.y = pix; % observed pixel

        % create ray template
        Lmk.Ray(id) = newRay(...
            Lmk.Ray(id),...
            id,...
            sMin,sMax,...
            alpha,beta,gamma,tau);

        % initialize ray
        Lmk.Ray(id) = rayInit(...
            Rob,...
            Cam,...
            Obs,...
            Lmk.Ray(id));

    
    end
    lmkId = lmkId + maxInit;
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

        % i. Do the match
        pix = Image(:,Lmk.Ray(i).id);
        
        Lmk.Ray(i).matched = 1;
        Lmk.Ray(i).y       = pix;

        % compute innovation statistics
        Lmk.Ray(i)         = uRayInnovation(...
            Lmk.Ray(i),...
            pix,...
            Obs.R);

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

    end

    % End of ray observations
    %------------------------------------------------------
    
%%    
    %------------------------------------------------------
    % Consistency data
    if con
        used = [Lmk.Pnt.used];
        used = find(used~=0);

        ids = [Lmk.Pnt(used).id];
        locs = [Lmk.Pnt(used).loc];

        x = reshape(Map.X(VDIM+1:end),3,[]);

        X = zeros(3,N);
        X(:,ids) = x(:,locs); % Estimated landmarks

        p = diag(Map.P);
        p = reshape(p(VDIM+1:end),3,[]);

        P = zeros(3,N);
        P(:,ids) = p(:,locs);
        S = sqrt(P);  % Estimated deviations
        
%         [W,F] = alignWorld(World);
        W = World;
        
        E = X - W; % Error wrt ground truth
        EoverS = E./(S+eps);
        EoverS(:,sum(X)==0)=0;
        
        ESx(f,:) = EoverS(1,:);
        ESy(f,:) = EoverS(2,:);
        ESz(f,:) = EoverS(3,:);
        
        % Robot position
        MR(f,:) = mahalanobis(RobSim.X(1:3),Rob.X(1:3),Map.P(1:3,1:3));
        
    end
    
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
      
    if plotUsed                         % map's used space subgraph
        usedLm = displayUsed(usedLm);
        maxLm = displayMaxUsed(maxLm);
    end


    % 3. video
    switch video
        case 0 % no video
            drawnow;
        case 1 % .avi
            aviVideoMapTop = videoFrame(aviVideoMapTop,fig1);
            aviVideoImg = videoFrame(aviVideoImg,fig2,ax21);
        case 2 % JPEG sequence
            imgFrame(fig2,sprintf(seqFileImg,f),ax21);
            imgFrame(fig1,sprintf(seqFileMapTop,f));
%             camorbit(ax1,0,-90)
%             imgFrame(fig1,sprintf(seqFileMapSide,f));
%             camorbit(ax1,0,90)
    end

    %
    % END OF VISUALIZATIONS
    %======================================================



%%
    %======================================================
    %
    % 3. ROBOT MOTION
    %=================

    % get odo reading
    Odo.u = [.1;0;0;0;0;0];
    Odo.u(3:5) = 0; % just 2D odometry
    un    = norm(Odo.u(1:WDIM)); % norm of step
    Udx   = un * dxNDR * [1 1 1]'; % translation noise variance
    Ude   = un * deNDR * [1 1 1]'; % rotation noise variance
    Ud    = [Udx;Ude];
    Odo.U = diag(Ud); % noise covariances matrix

    % 2.a.  Estimated motion with noisy data
    Rob = robotMotion(Rob,Odo);
    
    % Trajectory log
    Rob.traj(:,f) = Rob.X(1:3);
    
    % Simulated robot
    RobSim = odo3(RobSim,Odo.u + sqrt(Ud).*randn(size(Odo.u)));
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

% Consistency plot
if con
    % fig3 = figure(3);
    % ax31 = subplot(4,1,1);
    % plot(1:fmax,MR)
    % ylim([0 3]);grid
    % ax32 = subplot(4,1,2);
    % plot(1:fmax,ESx)
    % ylim([-2 2]);grid
    % ax33 = subplot(4,1,3);
    % plot(1:fmax,ESy)
    % ylim([-2 2]);grid
    % ax34 = subplot(4,1,4);
    % plot(1:fmax,ESz)
    % ylim([-3 3]);grid
    fig3 = figure(3);
    plot(1:fmax,abs(ESx))
    line(1:fmax,-MR,'linewidth',2,'color','b','linestyle','-')
    ylim([-3 3]);grid
    % ax32 = subplot(4,1,2);
    % ylim([-2 2]);grid
    % ax33 = subplot(4,1,3);
    % plot(1:fmax,ESy)
    % ylim([-2 2]);grid
    % ax34 = subplot(4,1,4);
    % plot(1:fmax,ESz)
    % ylim([-3 3]);grid

    % imgFrame(fig3,sprintf('~/Desktop/consistency_x_%1.2f_%1.1f.png',alpha,beta),ax31);
    % imgFrame(fig3,sprintf('~/Desktop/consistency_%1.2f_%1.1f.png',alpha,beta));
end


% Close video files
if video == 1
    aviVideo1 = closeVideo(aviVideo1);
    aviVideo2 = closeVideo(aviVideo2);
end
%
% ENF OF POST PROCESSING
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
