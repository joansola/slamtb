% Undelayed initialization of Plucker lines in monocular SLAM

%% START
clear 
clear global

% Experiment variables
experim = 'house';

% Simulation options
randSeed    = -1;
fmin        = 1;
fmax        = 140;
reproject   = 1;
noiseFactor = .5;
innSpace    = 'hh';

% camera frame
t = [0;0;1.5];
e = [-90;0;-120];
q = e2q(deg2rad(e));
camPos = [t;q];
camVel = zeros(6,1);

% odometry
odometry = [0;0;0.1;  0;deg2rad(-.55);0];

% Visualization options
mapView = 'view';
mapProj = 'persp';
drawEndPoints = true;
drawObservations = true;
drawCamera = 'on';
video = 0; % 0: no video; 1: img + 1 map; 2: img + 2 maps.


%%
% AUTOMATIC INITIALIZATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% some nice things
format compact
home
fprintf('\n This is Plucker-SLAM!\n\n\n');
if randSeed < 0
   clk = clock;
   randSeed = floor(100*clk(6)) % Make this run imprevisible but show seed
end
rand('state',randSeed);randn('state',randSeed);
if fmax < fmin, fmax = fmin; end

% Experiment directories
expdir = ['~/Documents/slam/Lines/' experim '/' innSpace '/']; % Experiment's root directory
if ~isdir(expdir)
    mkdir(expdir); 
end
figdir = [expdir 'figures/']; % directory for figures (frame captures mainly)
if ~isdir(figdir)
    mkdir(figdir); 
end

% Initialize simulation variables. 
% Edit the init files below to change behavior
initConst;
initWorld;
initCamera;
initLmks;
initObsTab;
initMap;
initImage;
% initHistorics;

% Initialize visualizations
initLog;
initMapFig;
initImageFig;
initVideo;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TIME EVOLUTION
%
%%%%%%%%%%%%%%%%%
%
% The sequence for each loop is:
%   1.  Landmark observations:  corrections and initializations at frame f
%   2.  Visualizations:         state at frame f
%   3.  Motions:                transition to frame f+1
%

for f = fmin:fmax 
    
%%
    %======================================================
    %
    % 1. LANDMARK OBSERVATIONS
    %==========================
    %
    % The sequence is:
    %   1.a  Take one photo
    %   1.b  Project lines
    %   1.c  Sort lines with big projected ellipse
    %   1.d  Observe Nl lines
    %   1.e  Get new lines in unpopulated image regions and
    %         initialize new lines
    %

    %   1.a  Take one photo
    %------------------------
    [obsSegments,visSegments] = projectSegment(SimuCam,world.segments);
    
    % pixel noise: add to observations
    obsSegments = obsSegments + noiseFactor*pixNoise*randn(size(obsSegments));
    
        
    
    %   1.d  Observe Nl lines
    %------------------------
    for i = 1:size(obsTab,2)
        if Lmk.Line(i).used && visSegments(i) % visible line

            % Search line
            obsTab(1,i).rawy = obsSegments(:,i); % measurement
            obsTab(1,i).rawR = Obs.rawR;
            
            % Compute innovations
            obsTab(1,i) = pluckerInnovation(obsTab(1,i),Cam,Lmk.Line(i),innSpace);
            
            if obsTab(1,i).MD < 6 
                
                % Match -> update
                Cam = lmkCorrection(Cam,Lmk.Line(i),obsTab(1,i));
                Lmk.Line(i).lost = 0;
                
            else
                
                % inconsistent -> count
                Lmk.Line(i).lost = Lmk.Line(i).lost + 1;

                if Lmk.Line(i).lost > 5
                    deletedLine = i
                    Lmk.Line(i) = deletePluckerLine(Lmk.Line(i));
                end
                
            end
            a = pluckerAngle(Map.X(Lmk.Line(i).r));
            c = cos(a);
            angle = rad2deg(a);
            if norm(c) > pi/180
                angle;
            end
        end
    end
    
    
    %   1.e  Initialize new lines
    %------------------------
    numInit = 0;
    for id = find(visSegments)

        % check max init
        if numInit >= maxInit
            break
        end

        if ~Lmk.Line(id).used % if line is not initialized
            
            % observation, go to homogeneous
            s = obsSegments(:,id);     % segment
            Rs = pixNoise^2*eye(4);    % noise covariance
            [hm,HMs] = seg2hm(s);      % homogeneous
            Rhm = HMs*Rs*HMs';         % noise covariance

            Obs.hm = hm;
            Obs.Rhm = Rhm;

            % Choose free line
            Lmk.Line(id).id = id;
            Lmk.Line(id).r  = getFreeRange(LMKDIM);

            % initialize
            if ~ isempty(Lmk.Line(id).r)
                Lmk.Line(id) = initPluckerLine(Lmk.Line(id),Cam,Obs,Beta);
            end
            
            % increment initialized lines counter
            numInit = numInit + 1;
        
        end
    end
    
    
    
%%
    %=======================================================
    %
    % 2. VISUALIZATIONS
    %==========================
    %
    % The sequence is:
    %   2.a  Show map
    %   2.b  Show image
    %   2.c  Update historics
    
    % Image plane
    if drawObservations
        dispProjWorld = drawProjWorld(dispProjWorld,obsSegments(:,visSegments));
    end
    obsTab = drawProjLines(obsTab,visSegments,imSize);
    
    % Map
    dispEstCam   = drawRobot(dispEstCam,Cam); 
    dispElliCam  = drawElliRobot(dispElliCam,Cam,ns);
    dispSimuCam  = drawRobot(dispSimuCam,SimuCam);
    dispMapLines = drawAllMapLines(dispMapLines,Lmk.Line,ns,drawEndPoints);
    
    drawnow
    
    % Video
    switch video
        case 1
            imgFrame(mapFig,sprintf(seqFileMap,f));
            imgFrame(imgFig,sprintf(seqFileImg,f));
        case 2
            imgFrame(mapFig,sprintf(seqFileMapTop,f));
            camorbit(mapAxes,0,-90)
            imgFrame(mapFig,sprintf(seqFileMapSide,f));
            camorbit(mapAxes,0,90)
            imgFrame(imgFig,sprintf(seqFileImg,f));
    end
    
    for i = find([Lmk.Line.used])
        r = Lmk.Line(i).r;
        Lmk.Line(i).hist(:,f) = Map.X(r);
        Lmk.Line(i).HIST(:,f) = diag(Map.P(r,r));
    end
    
    % Logs
    [ep,EP] = propagateUncertainty(Map.X(1:7),Map.P(1:7,1:7),@qpose2epose);
    Log.poses(:,f-fmin+1) = ep;
    Log.Poses(:,f-fmin+1) = diag(EP);
    Log.truth(:,f-fmin+1) = qpose2epose(SimuCam.X(1:7));
    rpos = 1:3;
    epos = Map.X(rpos);
    Epos = Map.P(rpos,rpos);
    tpos = SimuCam.X(rpos);
    nees = (tpos-epos)'*Epos^-1*(tpos-epos);
    Log.nees(1,f-fmin+1) = nees;
%     le = 2;
%     for lm = [1 10 13 14 22]
%         lr = Lmk.Line(lm).r;
%         epos = Map.X(r);
%         Epos = Map.P(r,r);
%         segm = world.segments(:,lm);
%         tpos = points2plucker(eu2hm(segm(1:3)),eu2hm(segm(4:6)));
%         nees = (tpos-epos)'*Epos^-1*(tpos-epos);
%         Log.nees(le,f-fmin+1) = nees;
%         le = le + 1;
%     end
        
    
%%
    %=======================================================
    %
    % 3. CAMERA MOTION
    %==========================
    %
    % The sequence is:
    %   3.a  Compute new simulation camera pose
    %   3.b  Predict new estimated camera pose
    %
    
    % Estimated camera
    % get odo reading
    dx  = odometry(1:3);
    de  = odometry(4:6);
    Odo = genOdo(dx,de,dxNDR,deNDR,noiseFactor);

    % Estimated camera - noisy - EKF predict
    Cam = odoPredict(Cam,Odo);
    
    % Simulated camera - nominal
    SimuCam = odo3(SimuCam,odometry);
    
    
end

%%

%================================
%
% 4. RESULTS
%====================

figure(3)
labl = {'x [m]','y [m]','z [m]'};
for i = 1:3
    subplot(3,2,2*i-1)
    plot(fmin:fmax,Log.poses(i,:)-Log.truth(i,:));
    title(labl{i});
    hold on
    plot(fmin:fmax,2*sqrt(Log.Poses(i,:)),'r');
    plot(fmin:fmax,-2*sqrt(Log.Poses(i,:)),'r');
    hold off
    xlim([fmin,fmax])
    grid
end

labl = {'roll [deg]','pitch [deg]','yaw [deg]'};
for i = 1:3
    subplot(3,2,2*i)
    plot(fmin:fmax,rad2deg(normAngle(Log.poses(3+i,:)-Log.truth(3+i,:))));
    title(labl{i});
    hold on
    plot(fmin:fmax,rad2deg(2*sqrt(Log.Poses(3+i,:))),'r');
    plot(fmin:fmax,-rad2deg(2*sqrt(Log.Poses(3+i,:))),'r');
    hold off
    xlim([fmin,fmax])
    grid
end


