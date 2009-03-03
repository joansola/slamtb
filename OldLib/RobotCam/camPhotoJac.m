function [Hc,Hp,Hcal,Hdist] = camPhotoJac(cam,p)

% CAMPHOTOJAC Jacobians of CAMPHOTO
%   [Hc,Hp] = CAMPHOTOJAC(CAM,P) gives the Jacobians
%   of CAMPHOTO evaluated at camera CAM and point P.
%   CAM is a structure with camera frame CAM.X
%   and calibration parameters CAM.cal. It can eventually contain
%   distorsion parameters CAM.dist.
%   Frame X must be specified in a vector [t;q] containing:
%     translation vector t
%     orientation quaternion q
%   Hc is the Jac. wrt camera pose
%   Hp is the Jac. wrt point position
%
%   [Hc,Hp,Hcal,Hdist] = PAMPHOTOJAC(...) gives the jacobians wrt
%   calibration parameters CAM.cal and distorsion parameters
%   CAM.dist.


% Point in camera frame
pc = toFrame(cam,p);

% toFrame Jacobians
[Tc,Tp] = toFrameJac(cam,p);

switch nargout
    case 2
        PHp = pinHoleJac(pc,cam);
    case 3
        [PHp,PHcal] = pinHoleJac(pc,cam);
        Hcal = PHcal;
    case 4
        [PHp,PHcal,PHdist] = pinHoleJac(pc,cam);
        Hcal  = PHcal;
        Hdist = PHdist;
end

% Output Jacobians
Hc = PHp*Tc;
Hp = PHp*Tp;

return

%% jacobians test

syms xc yc zc ac bc cc dc x y z real
cam = Cam(1);
cam.X = [xc;yc;zc;ac;bc;cc;dc];
cam = updateFrame(cam);
cam.cal = [u0 v0 au vu]';
cam.dist = [k2 k4]';
p   = [x;y;z];

[Hc,Hp,Hcal,Hdist] = camPhotoJac(cam,p);

% Hc - jacobian(camPhotoJac(cam,p))

