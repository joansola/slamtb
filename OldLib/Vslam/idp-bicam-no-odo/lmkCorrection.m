function [Rob,Cam] = lmkCorrection(Rob,Cam,Lmk)

% LMKCORRECTION  Landmark correction
%   ROB = LMKCORRECTION(ROB,CAM,LMK) performs an EKF correction
%   on global Map from previously computed landmark LMK
%   parameters. It also updates the robot ROB and camera CAM.
%
%   WARNING Proper quaternion normalization and ROB and CAM structures
%   updates must be done after this funciton.
%
%   See also NORMQUATROB.

global Map WDIM ODIM

rob = Rob.id;
cam = Cam.id;

% Robot
rr  = Rob.r;
Hr  = Lmk.Prj(rob).Hr;

% point
pr  = loc2range(Lmk.loc);
Hp  = Lmk.Prj(cam).Hp;

% Innovations
Inn.z  = Lmk.Prj(cam).z;
Inn.Z  = Lmk.Prj(cam).Z;
Inn.iZ = Lmk.Prj(cam).iZ;

% Map correction
blockUpdateInn(rr,pr,Hr,Hp,Inn,'simple');

