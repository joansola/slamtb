function visPnts = getVisPnts(Rob,Cam,Pnts)

% GETVISPNTS  Get visible points
%   I = GETVISPNTS(ROB,CAM,PNTS) returns the indices to points in the
%   structure array PNTS that are visible from the camera CAM in
%   the robot ROB.

global Map

used   = find([Pnts.used]); % used points in structure array
mloc   = [Pnts(used).loc];  % locations
mrange = mloc2mrange(mloc); % ranges
wpnts  = Map.X(mrange); % points in W frame
wpnts  = reshape(wpnts,3,size(mloc,2)); % points matrix

% projection
[pix,depth,front] = robCamPhoto(Rob,Cam,wpnts);

% test of field of view
inMat = pix>0 & pix<repmat(Cam.mat,1,size(wpnts,2));
inMat = inMat(1,:) & inMat(2,:);

% both tests
test = front & inMat;

% find winners among used and build index vector
visUsedPnts = find(test);

% find absolute winners
visPnts = used(visUsedPnts);
