function [Rob,Cam] = idpCorrection(Rob,Cam,Idp)

% IDPCORRECTION  Landmark correction
%   ROB = IDPCORRECTION(ROB,CAM,IDP) performs an EKF correction
%   on global Map from previously computed inverse depth landmark IDP
%   parameters. It also updates the robot ROB and camera CAM.

global Map WDIM ODIM

% Robot
rr  = Rob.r;

% Camera
cam = Cam.id;
cr  = Cam.r;
rcr = [rr cr];
Hrc = [Idp.Prj(cam).Hr Idp.Prj(cam).Hc];

% inverse depth point
ir  = loc2range(Idp.loc);
Hi  = Idp.Prj(cam).Hi;

% Innovations
Inn.z  = Idp.Prj(cam).z;
Inn.Z  = Idp.Prj(cam).Z;
Inn.iZ = Idp.Prj(cam).iZ;

% Map correction
blockUpdateInn(rcr,ir,Hrc,Hi,Inn,'simple');

% quaternion normalization
qr          = WDIM+1:WDIM+ODIM; % quat. range
[qn,QNq]    = normquat(Map.X(qr));
Map.X(qr)   = qn;
Map.P(qr,:) = QNq*Map.P(qr,:); % FIXME use good jacobians
Map.P(:,qr) = Map.P(:,qr)*QNq; % QNq is symmetric. It should be QNq' otherwise

if cam == 2
    % camera quaternion normalization
    [qn,QNq]    = normquat(Map.X(cr));
    Map.X(cr)   = qn;
    Map.P(cr,:) = QNq*Map.P(cr,:);
    Map.P(:,cr) = Map.P(:,cr)*QNq; % QNq is symmetric
end


% Robot and camera pose and matrices update
Rob.X         = Map.X(Rob.r);
Rob           = updateFrame(Rob);
Cam.X(Cam.or) = Map.X(Cam.r);
Cam           = updateFrame(Cam);

