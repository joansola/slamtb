function [Rob,Cam] = idpCorrection(Rob,Cam,Idp)

% IDPCORRECTION  IDP Landmark correction
%   ROB = IDPCORRECTION(ROB,CAM,IDP) performs an EKF correction
%   on global Map from previously computed inverse depth landmark IDP
%   parameters. It also updates the robot ROB and camera CAM.

global Map

% Robot
rr  = Rob.r;

% Camera
rob = Rob.id;
Hr = Idp.Prj(rob).Hr;

% inverse depth point
ir  = loc2range(Idp.loc);
Hi  = Idp.Prj(rob).Hi;

% Innovations
Inn.z  = Idp.Prj(rob).z;
Inn.Z  = Idp.Prj(rob).Z;
Inn.iZ = Idp.Prj(rob).iZ;

% Map correction
blockUpdateInn(rr,ir,Hr,Hi,Inn,'simple');

% check for negative depths
if Map.X(ir(6)) < 0
    Map.X(ir(6)) = 1e-2;
end

