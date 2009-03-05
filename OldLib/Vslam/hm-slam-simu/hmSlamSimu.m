% FISSLAMFULL  Federated Information Sharing SLAM with real data
%   Visual undelayed 3D-SLAM. This is the full algorithm with
%   data acquisition, image processing, tracking and SLAM.

% Copyright 2003-2006 Joan Sola @ LAAS-CNRS

%% START
% clear all variables
clear global; 
clear displayMaxUsed

% Experiment variables
site        = 'SIMU'
experim     = 'sparse01';
world       = 'random';

% Simulation options. On landmarks and map management
stats       = 1;
keepBack    = -Inf;     % Minimum depth in the map
reproject   = 0;       % Recompute jacobians at each lmk update
noiseFactor = 1;
fmin        = 1;
fmax        = 120;      % -1: take fmax = Nframes -1
randSeed    = -1;       % Make this run repeatable. -1: true random

% Visualization options
mapView     = 'top';   % Map view {top,normal,side,view}
mapProj     = 'ortho'; % Map projection type {orthographic,perspective}
plotUsed    = 0;       % Show map usage
video       = 0;       % 0: no video; 1: avi; 2: save JPG images
con         = 0;       % consistency test

DT = .0;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% AUTOMATIC INITIALIZATIONS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% some nice things
format compact
home
fprintf('\n This is HM-SLAM!\n\n\n');
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
% load(loadfile);
camera.cal    = [160; 120; 160; 160];
camera.imSize = [320; 240;];
camera.X      = [ 0;0;1.1;0.5;-0.5;0.5;-0.5];

% Initialize simulation variables
if fmax < fmin, fmax = fmin; end
Nframes = fmax-fmin+1;
initConst;
%if stats
%    simultPnt = UpPerFrame(nn); % overwrite updates per frame
%end
initRobot;
initCamera;
initWorld;
initLmks;
initMap;
initImage;


% Initialize visualizations
initMapFig;
initImageFig;
initVideo;

% Data logging
N   = size(World,2); % Nbr of landmarks in world
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
    %   1.e  Initialize new points
    %

    
%%
    %------------------------------------------------------
    %
    % 1.a) Take one photo
    %---------------------

    Image = simShot(RobSim,Cam,World,noiseFactor*pixNoise);
%     Image = simShot(RobSim,Cam,World);
    %
    %------------------------------------------------------



%%
    %------------------------------------------------------
    %
    % 1.b) Project points
    %---------------------

    for i = find([Lmk.Pnt.used])
        Lmk.Pnt(i) = projectHomo(Rob,Cam,Lmk.Pnt(i));
        if Lmk.Pnt(i).front == 0
            i
            Map.X(loc2range(Lmk.Pnt(i).loc))
            Lmk.Pnt(i);
        end
    end

    % delete points behind camera
    backPnts = [Lmk.Pnt.used] & ([Lmk.Pnt.s] < keepBack);
    for i = find(backPnts)
        Lmk.Pnt(i).used = false;
        liberateMap(Lmk.Pnt(i).loc);
    end

    % 1. Image plane figure
%     displImage;                         % Display image
%     dispObsPnts
%     dispProjPnts;
%     drawnow
%     pause(DT/2)


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
            Lmk.Pnt(i) = projectHomo(Rob,Cam,Lmk.Pnt(i));
        end

        % i. Search patch
        pix = Image(:,Lmk.Pnt(i).id);
%         pix = Image(:,Lmk.Pnt(i).id) + noiseFactor*pixNoise.*randn(2,1);

        Lmk.Pnt(i).matched = 1;
        Lmk.Pnt(i).y       = pix;

        Lmk.Pnt(i)         = uPntInnovation(...
            Lmk.Pnt(i),...
            pix,...
            Obs.R);


        Lmk.Pnt(i).updated = 1;
        Lmk.Pnt(i).lost    = 0;

        % move landmark
%         Lmk.Pnt(i) = moveLandmark(Lmk.Pnt(i));

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
    % 1.e) Initialize new points
    %--------------------------------------------------

    % lmks to initialize
    for id = lmkId:min(lmkId + maxInit - 1,size(World,2));

        % i. look for new Harris points
        pix   = detectFeature(Image,id);
        
        if any(pix==Inf)
            break
        end

        % ii. Initialize rays
        Obs.y = pix; % observed pixel

        % create homog. pnt template
        Lmk.Pnt(id) = newHomo(...
            Lmk.Pnt(id),...
            id);
        
        Lmk.Pnt(id).y = Obs.y;
        Lmk.Pnt(id).u = Obs.y;
        Lmk.Pnt(id).U = zeros(2);
        Lmk.Pnt(id).matched = true;
        Lmk.Pnt(id).updated = true;
        Lmk.Pnt(id).lost = 0;
        

        % initialize ray
        Lmk.Pnt(id) = partialInit(...
            Rob,...
            Cam,...
            Obs,...
            Rho,...
            Lmk.Pnt(id),...
            @homoInvRobCamPhotoPix);

    
    end
    lmkId = lmkId + maxInit;
    %
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
    dispObsPnts
    dispProjPnts;
    
    % 2. Map figure
    dispMapPnts
    dispEstRob = displayRobot(dispEstRob,dispEstElli,Rob,ns);      % Robot
    dispEstCam = displayCamera(dispEstCam,Rob,Cam); % Camera 
      
    if plotUsed                         % map's used space subgraph
        usedLm = displayUsed(usedLm);
        maxLm = displayMaxUsed(maxLm);
    end
        
    pause(DT/2)


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

    % STATS
    ts = RobSim.X(1:3);
    es = q2e(RobSim.X(4:7));
    t = Rob.X(1:3);
    q = Rob.X(4:7);
    Pt = Map.P(1:3,1:3);
    Pq = Map.P(4:7,4:7);
    [e,Eq] = q2e(q);
    Pe = Eq*Pq*Eq';
    Ct = diag(Pt);
    Ce = diag(Pe);
    
    %if stats
    %    ErrorTraj(:,f,nn) = [t-ts;e-es];
    %    SigmaTraj(:,f,nn) = sqrt([Ct;Ce]);
    %end


%%
    %======================================================
    %
    % 3. ROBOT MOTION
    %=================

    % get odo reading
    Odo.u = [0.;0.1;0;0;0;2*eps];
    un    = norm(Odo.u(1:WDIM)); % norm of step
    Udx   = un * dxNDR * [1 1 1]'; % translation noise variance
    Ude   = un * deNDR * [1 1 1]'; % rotation noise variance
    Ud    = [Udx;Ude];
    Odo.U = diag(Ud); % noise covariances matrix

    % 2.a.  Estimated motion with non-noisy data
    Rob = robotMotion(Rob,Odo);
    
    % Trajectory log
    Rob.traj(:,f) = Rob.X(1:3);
    
    % Simulated robot motion with noisy data
    RobSim = odo3(RobSim,Odo.u + noiseFactor*sqrt(Ud).*randn(size(Odo.u)));
    
    % update frames
    Rob = updateFrame(Rob);
    RobSim = updateFrame(RobSim);
    
    %
    % END OF ROBOT MOTION
    %======================================================

    

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

% Coarse error evaluation of robot position
fprintf(...
    ' Robot 3-sigma uncertainty from P is about %4.2f x %4.2f x %4.2f mm\n\n',...
    3000*sqrt(Map.P(1,1)),...
    3000*sqrt(Map.P(2,2)),...
    3000*sqrt(Map.P(3,3)));

%
% ENF OF POST PROCESSING
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
