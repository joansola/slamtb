% FISBICAM-MOT  FIS-BiCamSLAM with Moving Objects Tracking.
%   Visual undelayed 3D-SLAM. This is the full algorithm with
%   data acquisition, image processing, SLAM and moving objects
%   tracking.

% Copyright 2003-2006 Joan Sola @ LAAS-CNRS
clear ; clear global

% Experiment variables
experim     = 'serie39';
expType     = 'bicam';
imType      = 'originals';

% Simulation options. On landmarks and map management
selfCalib   = 1;
keepBack    = -8;   % Minimum depth in the map
reproject   = 1;    % Recompute jacobians at each lmk update
fmin        = 30;
fmax        = 150; % -1: take fmax = Nframes -1
randSeed    = 1481; % Make this run repeatable. -1: true random

% Visualization options
mapView     = 'top';   % Map view {top,normal,side,view}
mapProj     = 'ortho'; % Map projection type {orthographic,perspective}
plotVray    = 0;       % Show virtual ray
plotCalib   = 0;       % Show calibration; 2: in text mode also
plotPatches = 0;       % Show landmark's patches figure
plotUsed    = 1;       % Show map usage
equalizeIm  = 0;       % Image gray equalization
video       = 0;       % 0: no video; 1: avi;



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
   '~/Documents/Doctorat/slam/FIS-SLAM/Experiments/Dala/' ...
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
initObjs;
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

if plotCalib
   ec   = zeros(3,fmax-fmin+2);
   eec  = zeros(3,fmax-fmin+2);
   ff   = repmat([fmin-1:fmax],3,1);

   cr   = Cam(2).r;
   q_rs = Map.X(cr);       % quaternion robot frame
   Qrs  = Map.P(cr,cr);    % quaternion noise robot frame
   Rcs  = flu2rdf();       % Camera to sensor rotation matrix
   Rrs  = Cam(2).R;        % Robot to sensor rotation matrix
   Rrc  = Rrs*Rcs';        % Robot to camera rotation matrix
   JqE  = q2erdfJac(q_rs);
   Erc  = JqE*Qrs*JqE';    % noise robot frame

   ec(:,1)  = rad2deg(R2e(Rrc));
   eec(:,1) = rad2deg(sqrt(diag(Erc)));
   if plotCalib == 2
      ec_eec   = [ec(:,1) eec(:,1)]
   end

   fig3 = figure(3);
   clf
   set(fig3,'pos',[1   371   410   300]);
   calib = line(ff',ec','linewidth',2);
   calib(4:6) = line(ff',5*eec','linestyle','--');
   axis([fmin-1 fmax -1 6]);
end

for f = fmin:fmax

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
   % end of image acquisition
   %------------------------------------------------------




   %------------------------------------------------------
   %
   % 1.b) Project points onto images
   %---------------------------------

   for pnt = find([Lmk.Pnt.used])
      for cam = 1:2
         Lmk.Pnt(pnt) = projectPnt(...
            Rob,...
            Cam(cam),...
            Lmk.Pnt(pnt),...
            Obs(cam).R);
      end
      Lmk.Pnt(pnt) = summarizePnt(Lmk.Pnt(pnt));
   end

   % delete points behind camera
   backPnts = [Lmk.Pnt.used] & ([Lmk.Pnt.s] < keepBack);
   for pnt = find(backPnts)
      Lmk.Pnt(pnt).used = false;
      liberateMap(Lmk.Pnt(pnt).loc);
   end
   %
   % end of points projection
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
   % End of points selection
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
   for pnt = bigPnts % for each point to observe

      for cam = 1:2 % with each camera

         if Lmk.Pnt(pnt).Prj(cam).vis % visible points only

            Lmk.Pnt(pnt) = measurePnt(...
               Rob,...
               Cam(cam),...
               Lmk.Pnt(pnt),...
               ns,...
               reproject,...
               Obs(cam));

            pixFound = (Lmk.Pnt(pnt).Prj(cam).sc > foundPixTh);

            if pixFound % Pixel found

               Lmk.Pnt(pnt).Prj(cam).matched = 1;
               Obs(cam).y  = Lmk.Pnt(pnt).Prj(cam).y;

               Lmk.Pnt(pnt)  = uPntInnovation(...
                  Lmk.Pnt(pnt),...
                  cam,...
                  Obs(cam).y,...
                  Obs(cam).R);

            else  % Pixel not found

               Lmk.Pnt(pnt).Prj(cam).matched = 0;
               Lmk.Pnt(pnt).Prj(cam).y       = [];

            end

            pixGood = pixFound && (Lmk.Pnt(pnt).Prj(cam).MD < MDth);

            % ii. Good match
            if pixGood
               Lmk.Pnt(pnt).Prj(cam).updated = 1;
               %                Lmk.Pnt(pnt).lost    = 0;
               Lmk.Pnt(pnt).found = Lmk.Pnt(pnt).found + 1;

               % move landmark
               Lmk.Pnt(pnt) = moveLandmark(Lmk.Pnt(pnt));

               % correct map
               [Rob,Cam(cam)] = lmkCorrection(...
                  Rob,...
                  Cam(cam),...
                  Lmk.Pnt(pnt));

               updates = updates + 1;

            else  % iii. Bad or no match

               Lmk.Pnt(pnt).Prj(cam).updated = 0;
               Lmk.Pnt(pnt).lost = Lmk.Pnt(pnt).lost + 1;

            end % good or bad match

         end % visible point

      end % cameras


      %       if Lmk.Pnt(pnt).lost > lostPntTh
      if Lmk.Pnt(pnt).lost > Lmk.Pnt(pnt).found
         % delete landmark
         Lmk.Pnt(pnt).used = false;
         liberateMap(Lmk.Pnt(pnt).loc);
      else
         % move landmark
         Lmk.Pnt(pnt) = moveLandmark(Lmk.Pnt(pnt));
      end


      if updates >= Lmk.simultPnt
         break
      end

   end % points
   %
   % end of point observations
   %------------------------------------------------------




   %------------------------------------------------------
   %
   % 1.e) Project rays
   %-------------------

   for ray = find([Lmk.Ray.used])
      for cam = 1:length(Cam)
         Lmk.Ray(ray) = projectRay(...
            Rob,...
            Cam(cam),...
            Lmk.Ray(ray),...
            Obs(cam).R);
      end
      Lmk.Ray(ray) = summarizeRay(Lmk.Ray(ray));
   end


   % Delete non visible rays
   nonVisRays = lastUsedRays & ~[Lmk.Ray.vis0];
   for ray = find(nonVisRays)
      Lmk.Ray(ray).used = false;
      loc = Lmk.Ray(ray).loc(1:Lmk.Ray(ray).n);
      liberateMap(loc);
   end

   % Remember previous rays' indices
   lastUsedRays = [Lmk.Ray.used];
   %
   % End of rays projection
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
   % End of rays selection
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
   for ray = bigRays

      for cam = 1:length(Cam) % for each camera


         % re-project ray to get actual linearizations
         if reproject
            Lmk.Ray(ray) = projectRay(...
               Rob,...
               Cam(cam),...
               Lmk.Ray(ray),...
               Obs(cam).R);
         end


         if Lmk.Ray(ray).Prj(cam).vis0  % visible rays only

            Lmk.Ray(ray) = measureRay(...
               Rob,...
               Cam(cam),...
               Lmk.Ray(ray),...
               ns);

            pixFound = (Lmk.Ray(ray).Prj(cam).sc > foundPixTh);

            if pixFound  % Pixel found

               Lmk.Ray(ray).Prj(cam).matched = 1;
               Obs(cam).y   = Lmk.Ray(ray).Prj(cam).y;

               % compute innovation statistics
               Lmk.Ray(ray) = uRayInnovation(...
                  Lmk.Ray(ray),...
                  cam,...
                  Obs(cam).y,...
                  Obs(cam).R);

            else  % Pixel not found

               Lmk.Ray(ray).Prj(cam).matched = 0;
               Lmk.Ray(ray).Prj(cam).y       = [];

            end



            pixGood = pixFound && (min(Lmk.Ray(ray).Prj(cam).MD) < MDth);

            if  pixGood % ii. Good match

               Lmk.Ray(ray).Prj(cam).updated = 1;
               %                Lmk.Ray(ray).lost             = 0;
               Lmk.Ray(ray).found = Lmk.Ray(ray).found + 1;

               Lmk.Ray(ray) = balWeight(Lmk.Ray(ray)); % re-balance weights
               Lmk.Ray(ray) = updateWeight(Lmk.Ray(ray),cam); % update weights
               Lmk.Ray(ray) = pruneRay(Lmk.Ray(ray)); % prune ray members
               Lmk.Ray(ray) = pruneTwinPoints(Lmk.Ray(ray)); % prune twin members

               liberateMap(Lmk.Ray(ray).pruned); % remove pruned ray members from map

               % FIS-correct map
               [Rob,Cam(cam)] = FISUpdate(Rob,Cam(cam),Lmk.Ray(ray),Obs(cam));

               updates = updates + 1;

            else % iii. Bad or no match

               Lmk.Ray(ray).Prj(cam).updated = 0;
               Lmk.Ray(ray).lost = Lmk.Ray(ray).lost + 1;

            end % of Good or bad matches

         end % of visible rays

      end % of cameras


      if Lmk.Ray(ray).n == 1 % Is single member

         % convert to single point
         newPnt = getFree([Lmk.Pnt.used]);
         [Lmk.Ray(ray),Lmk.Pnt(newPnt)] = ray2pnt(...
            Lmk.Ray(ray),...
            Lmk.Pnt(newPnt),...
            lostPntTh);
      end


      %       if Lmk.Ray(ray).lost > lostRayTh % if lost
      if Lmk.Ray(ray).lost > Lmk.Ray(ray).found
         % Delete ray
         Lmk.Ray(ray).used = false;
         liberateMap(Lmk.Ray(ray).loc(1:Lmk.Ray(ray).n));
      end


      if updates >= Lmk.simultRay
         break
      end

   end % of rays
   %
   % End of ray observations
   %------------------------------------------------------



   %------------------------------------------------------
   %
   % 1.h) Project objects.
   %
   %------------------------------------------------------
   %
   for obj = find([Obj.used])
      for cam = 1:2
         Obj(obj) = projectObject(Cam(cam),Obj(obj),Obs(cam).R);

      end
      Obj(obj) = summarizeObj(Obj(obj));
      if Obj(obj).vis0 == 0 % Object non visible- delete it
         Obj(obj).used = 0;
      end
   end
   %------------------------------------------------------


   %------------------------------------------------------
   %
   % 1.h) Observe objects.
   %
   %   i. Project objects
   %  ii. Search patch
   % iii. Correct objects
   %------------------------------------------------------
   %
   for obj = find([Obj.used])
      for cam = 1:length(Cam)
         % i. Perform measure with eventual reprojection
         [Obj(obj),Obs(cam)] = measureObj(Rob,Cam(cam),Obj(obj),ns,reproject,Obs(cam));

         % TODO: condition the following to a good match:
         pixFound = (Obj(obj).Prj(cam).sc > foundObjTh);

         if pixFound % Pixel found

            Obj(obj).Prj(cam).matched = 1;

            Obj(obj) = uPntInnovation(Obj(obj),cam,Obs(cam).y,Obs(cam).R);

         else  % Pixel not found

            Obj(obj).Prj(cam).matched = 0;
            Obj(obj).Prj(cam).y       = [];

         end

         pixGood = pixFound && (Obj(obj).Prj(cam).MD < MDth);

         % ii. Good match
         if pixGood
            Obj(obj).Prj(cam).updated = 1;
            Obj(obj).lost             = 0;
            Obj(obj).found            = Obj(obj).found + 1;

            % correct object
            Obj(obj) = correctObject(Cam(cam),Obj(obj));

            %             updates = updates + 1;

         else  % iii. Bad or no match

            Obj(obj).Prj(cam).updated = 0;
            Obj(obj).lost = Obj(obj).lost + 1;

         end % good or bad match

      end

      if Obj(obj).lost > lostObjTh
         %       if Obj(obj).lost > Obj(obj).found
         % delete landmark
         Obj(obj).used = false;
      else
         vr = WDIM+[1:WDIM];
         nv = norm(Obj(obj).x(vr));
         nPv = det(Obj(obj).P(vr,vr))^(1/6);
         if nv<.05 && nPv < .2 % Is a steady object

            % convert to single point
            newPnt = getFree([Lmk.Pnt.used]);
            [Obj(obj),Lmk.Pnt(newPnt)] = obj2pnt(...
               Rob,...
               Obj(obj),...
               Lmk.Pnt(newPnt),...
               lostPntTh);
         end

      end

      %       projectAllObjs;
      %       dispProjObj = dispProjObjs(dispProjObj,Obj,maxObj,ns);
      %       drawnow


   end
   %
   % End of object observations
   %------------------------------------------------------


   %------------------------------------------------------
   %
   % 1.h) Initialize new landmarks - points or rays
   %------------------------------------------------

   % number of existing landmarks per region
   subImage = countLmks(subImage,Obj);

   % Maximum allowable initializations
   maxNewInit = getMaxInit;

   % rays to initialize per region
   subImage = numInit(subImage);
   regIdx   = find(subImage.numInit);
   regIdx   = randSort(regIdx);

   newInit  = 0;

   for i = regIdx % at each region with not enough points:

      % i. look for new Harris points
%       [pix,sc]   = NharrisRegion(1,subImage,i,mrg,hSgm,hTh,hRd,hMet);
      [pix,sc]   = NharrisRegion(1,subImage,i,mrg,hSgm,[],hRd,hMet);
      newInitReg = min(size(pix,2),maxNewInit-newInit);

      for j = 1:newInitReg

         % Define virtual ray
         Obs(1).y = pix(:,j); % observed pixel

         [vRay,Obs] = initVRayBicam(...
            Rob,Cam,Obs,...
            sMin,alpha,...
            patchSize,ns);

         % graphics
         if plotVray
            [vRayHdle,vRay] = drawVray(vRayHdle,vRay,ns);
            switch video
               case 0 % no video
                  drawnow;
               case 1 % .avi
                  aviVideo3 = videoFrame(aviVideo3,fig2);
            end
         end


         pixFound = (vRay.Prj(2).sc > foundPixTh);

         if pixFound

            % Match things
            vRay.Prj(2).matched = 1;

            % Check distance to epipolar
            [d,u1,u2] = epiDist(vRay,Obs(2).y);

            % 1-sigma ellipse of innovations
            Z2       = vRay.Prj(2).Z(:,:,2);
            sigma2u  = sqrt(Z2(1,1));
            sigma2v  = sqrt(Z2(2,2));

            pixGood = (d < ns*sigma2v);

            if pixGood % found pix is inside search region

               % Critical pixel for observability
               yCrit = u2 - [4*sigma2u;0]; % 4sigma criterion
               depth3d = (Obs(2).y(1) < yCrit(1));

               if depth3d  % Full 3D initialization
                  [Rob,Cam] = initPntBicam(Rob,...
                     Cam,...
                     vRay,...
                     Obs,...
                     alpha,...
                     patchSize,...
                     lostPntTh);

               else % Partial initialization
                  [Rob,Cam] = initRayBicam(...
                     Rob,Cam,...
                     vRay,Obs,yCrit,...
                     sMax,...
                     alpha,beta,gamma,tau,...
                     patchSize,lostRayTh);

               end % of depth3d

            end % of pixel good

         end % of pixel found

      end % of init new region

      newInit = newInit + newInitReg;
      if newInit >= maxNewInit
         break  % Stop searching regions
      end

   end
   %
   % End of landmark initializations
   %------------------------------------------------------


   %------------------------------------------------------
   %
   % Objects creation
   %------------------

   % Existing objects per cell and cells to initialize objects
   subObjImage = countLmks(subObjImage,Obj);
   subObjImage = numInit(subObjImage);

   cellIdx = find((subObjImage.minReg-subObjImage.numFtr)>0);
   cellIdx = randSort(cellIdx); % cells where to initialize objects

   newInit = 0;

   for i = cellIdx

%       [pix,sc]   = NharrisRegion(1,subObjImage,i,0,hSgm,hTh,hRd,hMet);
      [pix,sc]   = NharrisRegion(1,subObjImage,i,0,hSgm,[],hRd,hMet);

      if numel(sc);

         % Define virtual ray
         Obs(1).y = pix(:,1); % strongest observed pixel

         [vRay,Obs] = initVRayBicam(...
            Rob,Cam,Obs,...
            sMin,alpha,...
            patchSize,ns);

         pixFound = (vRay.Prj(2).sc > foundPixTh);

         if pixFound

            % Match things
            vRay.Prj(2).matched = 1;

            % Check distance to epipolar
            [d,u1,u2] = epiDist(vRay,Obs(2).y);

            % 1-sigma ellipse of innovations
            Z2       = vRay.Prj(2).Z(:,:,2);
            sigma2u  = sqrt(Z2(1,1));
            sigma2v  = sqrt(Z2(2,2));

            pixGood = (d < ns*sigma2v);

            if pixGood % found pix is inside search region

               % Critical pixel for observability
               yCrit = u2 - [4*sigma2u;0]; % 4sigma criterion
               depth3d = (Obs(2).y(1) < yCrit(1));

               if depth3d  % Full 3D initialization

                  Obj = initObjBicam(...
                     Rob,Cam,Obj,...
                     vRay,Obs,...
                     Vel,Pert,...
                     alpha,...
                     patchSize,lostObjTh);

                  %                   projectAllObjs;
                  %                   dispProjObj = dispProjObjs(dispProjObj,Obj,maxObj,ns);
                  %                   drawnow

               end % of depth3d

            end % of pixel good

         end % of pixel found


      end % of this cell


   end
   %
   % End of objects creation
   %------------------------------------------------------

   %
   % END OF LANDMARK OBSERVATIONS
   %======================================================






   %======================================================
   %
   % 2. VISUALIZATIONS
   %===================

   %------------------------------------------------------
   %
   % 2.a 3D estimates and 2D projections
   %-------------------------------
   for obj = find([Obj.used])
      Obj(obj) = estimateObject(Rob,Obj(obj));
   end
   projectAllLmks;
   projectAllObjs;

   %------------------------------------------------------
   %
   % 2.b graphics
   %---------------
   % 1. Image plane figure
   dispImage   = displImage  (dispImage);
   dispProjRay = dispProjRays(dispProjRay,ns);
   dispProjPnt = dispProjPnts(dispProjPnt,ns);
   dispProjObj = dispProjObjs(dispProjObj,Obj,maxObj,ns);
   if plotVray
      [vRayHdle,vRay] = drawVray(vRayHdle,vRay,ns);
   end

   % 2. Map figure
   dispMapRay = dispMapRays  (dispMapRay,ns );
   dispMapPnt = dispMapPnts  (dispMapPnt,ns );
   dispMapObj = dispMapObjs  (dispMapObj,Obj,maxObj,ns );
   dispEstRob = displayRobot (dispEstRob,Rob);
   dispEstCam = displayCamera(dispEstCam,Rob,Cam);


   if plotUsed    % map's used space subgraph
      usedLm = displayUsed   (usedLm);
      maxLm  = displayMaxUsed(maxLm);
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
         aviVideo1 = videoFrame(aviVideo1,fig1);
         camorbit(0,-90);
         aviVideo2 = videoFrame(aviVideo2,fig1);
         camorbit(0,90);
         aviVideo3 = videoFrame(aviVideo3,fig2);
   end
   %
   % END OF VISUALIZATIONS
   %======================================================


   %======================================================
   %
   % 2.bis. DATA COLLECTION
   %========================

   if plotCalib
      % Camera orientation error estimate
      cr   = Cam(2).r;
      q_rs = Map.X(cr);      % quaternion  robot frame
      Qrs  = Map.P(cr,cr);    % quaternion noise robot frame
      Rcs  = flu2rdf();       % Camera to sensor rotation matrix
      Rrs  = Cam(2).R;        % Robot to sensor rotation matrix
      Rrc  = Rrs*Rcs';        % Robot to camera rotation matrix
      JqE  = q2erdfJac(q_rs);
      Erc  = JqE*Qrs*JqE';    % noise robot frame

      ec(:,f-fmin+2)  = rad2deg(R2e(Rrc));
      eec(:,f-fmin+2) = rad2deg(sqrt(diag(Erc)));
      if plotCalib == 2
         ec_eec   = [ec(:,f-fmin+2) eec(:,f-fmin+2)]
      end

      for i=1:3
         set(calib(i),'ydata',ec(i,:)');
         set(calib(i+3),'ydata',5*eec(i,:)');
      end
      %     legend('roll','pitch','yaw')
   end
   
   %    if mod(f-fmin,7) == 0 % one every 7 frames
   %       frm = getframe(ax1);
   %       mapName = sprintf('mot-map-%03d.bmp',f);
   %       mapName = [figdir mapName];
   %       imwrite(frm.cdata,mapName);
   %       frm = getframe(ax2(1));
   %       imgName = sprintf('mot-img-%03d.bmp',f);
   %       imgName = [figdir imgName];
   %       imwrite(frm.cdata,imgName);
   %    end
   %
   % END OF DATA COLLECTION
   %======================================================



   %======================================================
   %
   % 3. MOTIONS
   %============

   %------------------------------------------------------
   %
   % 3.a robot motion
   %------------------

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


   %------------------------------------------------------
   %
   % 3.a objects reframing and motion
   %----------------------------------

   for obj = find([Obj.used])
      % reframe
      Obj(obj) = reframeObject(Obj(obj),Odo);

      % motion
      Obj(obj) = moveObject(Obj(obj),Ts);
   end

   %    projectAllObjs;
   %    dispProjObj = dispProjObjs(dispProjObj,Obj,maxObj,ns);
   %    drawnow

   %
   % END OF MOTIONS
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
% fprintf(...
%     ' Robot uncertainty from P is about %4.2f x %4.2f x %4.2f mm\n\n',...
%     1000*sqrt(Map.P(1,1)),...
%     1000*sqrt(Map.P(2,2)),...
%     1000*sqrt(Map.P(3,3)));

% Close video files
if video
   aviVideo1 = closeVideo(aviVideo1);
   aviVideo2 = closeVideo(aviVideo2);
   aviVideo3 = closeVideo(aviVideo3);
end
%
% ENF OF POST PROCESSING
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
