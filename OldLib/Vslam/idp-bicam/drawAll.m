% DRAWALL  Draw all graphics objects



% 1. Image plane figure
dispImage = displImage(dispImage);              % Display image
dispProjRay = dispProjRays(dispProjRay,ns);
dispProjPnt = dispProjPnts(dispProjPnt,ns);

% 2. Map figure
dispMapRay = dispMapRays(dispMapRay,ns);        % 3D ellipsoids
dispMapPnt = dispMapPnts(dispMapPnt,ns);
dispEstRob = displayRobot(dispEstRob,Rob);      % Robot
dispEstCam = displayCamera(dispEstCam,Rob,Cam); % Camera

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
        aviVideo1 = videoFrame(aviVideo1,fig1);
        aviVideo2 = videoFrame(aviVideo2,fig2);
end
