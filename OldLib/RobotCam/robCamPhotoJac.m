function [Hr,Hc,Hp,Hcal,Hdist,pr,pc] = robCamPhotoJac(R,cam,p)

% ROBCAMPHOTOJAC Jacobians of ROBCAMPHOTO
%   [Hr,Hc,Hp] = ROBCAMPHOTOJAC(R,CAM,P) gives the Jacobians
%   of ROBCAMPHOTO evaluated at robot pose R, camera CAM
%   and point P.
%   CAM is a structure with camera frame CAM.X
%   and calibration parameters CAM.cal.
%     Hr is the Jac. wrt robot pose
%     Hc is the Jac. wrt camera pose
%     Hp is the Jac. wrt point position.
%
%   Frames R and C must be specified in vectors containing:
%     translation vector t
%     orientation quaternion q
%
%   [Hr,Hc,Hp,Hcal,Hdist] = ROBCAMPHOTOJAC(...) gives the
%   Jacobians wrt the camera parameters CAM.cal and CAM.dist.
%   
%   [Hr,Hc,Hp,Hcal,Hdist,Pr,Pc] = (...) returns also:
%     Pr: the point P expressed in R frame
%     Pc: the point P expressed in CAM frame



% Point in robot frame
pr = toFrame(R,p);

% Point in camera frame
pc = toFrame(cam,pr);

switch nargout
    case 3
        PHp = pinHoleJac(pc,cam);
    case 4
        [PHp,PHcal] = pinHoleJac(pc,cam);
        Hcal = PHcal;
    case 5
        [PHp,PHcal,PHdist] = pinHoleJac(pc,cam);
        Hcal = PHcal;
        Hdist = PHdist;
end


% toFrame R Jacobians
[TRf,TRp] = toFrameJac(R,p);

% toFrame C Jacobians
[TCf,TCp] = toFrameJac(cam,pr);


% Output Jacobians
Hr = PHp*TCp*TRf;
Hc = PHp*TCf;
Hp = PHp*TCp*TRp;
