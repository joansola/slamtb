function [Rob,Cam] = lmkCorrection(Rob,Cam,Lmk)

% LMKCORRECTION  Landmark correction
%   [ROB,CAM] = LMKCORRECTION(ROB,CAM,LMK) performs an EKF 
%   correction on global Map from previously computed landmark LMK
%   parameters. It also updates the robot ROB and camera CAM.

global Map WDIM ODIM

% Robot
rr  = Rob.r;

% Camera
cam = Cam.id;
cr  = Cam.r;
rcr = [rr cr];
Hrc = [Lmk.Prj(cam).Hr Lmk.Prj(cam).Hc];

% point
pr  = loc2range(Lmk.loc);
Hp  = Lmk.Prj(cam).Hp;

% Innovations
Inn.z  = Lmk.Prj(cam).z;
Inn.Z  = Lmk.Prj(cam).Z;
Inn.iZ = Lmk.Prj(cam).iZ;

% Map correction
blockUpdateInn(rcr,pr,Hrc,Hp,Inn,'symmet');

% quaternion normalization
qr          = WDIM+1:WDIM+ODIM; % quat. range
iqn         = 1/norm(Map.X(qr));
Map.X(qr)   = Map.X(qr)*iqn;
Map.P(qr,:) = Map.P(qr,:)*iqn; % FIXME use good jacobians
Map.P(:,qr) = Map.P(:,qr)*iqn;

if cam == 2
    % camera quaternion normalization
    iqn         = 1/norm(Map.X(cr));
    Map.X(cr)   = Map.X(cr)*iqn;
    Map.P(cr,:) = Map.P(cr,:)*iqn;
    Map.P(:,cr) = Map.P(:,cr)*iqn;
end


% Robot and camera pose and matrices update
Rob.X         = Map.X(Rob.r);
Rob           = updateFrame(Rob);
Cam.X(Cam.or) = Map.X(Cam.r);
Cam           = updateFrame(Cam);

