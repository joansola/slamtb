function [Gr,Gc,Gw,Gs,Gcal,Gundist] = ...
    invRobCamPhotoJac(R,cam,pix,s)

% INVROBCAMPHOTOJAC Jacobians of INVROBCAMPHOTO
%   [Gr,Gc,Gw,Gs] = INVROBCAMPHOTOJAC(R,CAM,PIX,S) gives the
%   Jacobians of INVROBCAMPHOTO evaluated for a robot R, a camera
%   CAM at pixel PIX and depth S. CAM is a structure with
%   camera frame CAM.C and calibration parameters CAM.cal.
%     Gr is the Jac. wrt robot pose
%     Gc is the Jac. wrt camera pose
%     Gw is the Jac. wrt pixel
%     Gs is the Jac. wrt depth
%
%   Frames R and C must be specified in a vector containing:
%     translation vector t
%     orientation quaternion q
%
%   [Gr,Gc,Gw,Gs,Gcal,Gundist] = INVROBCAMPHOTOJAC(...) gives
%   Jacobian wrt calibration parameters of the camera CAM.cal and
%   the inverse distortion parameters CAM.undist


% retroprojected point in camera frame
pc = invPinHole(pix,s,cam);

% Retroprojected point in robot frame
pr = fromFrame(cam,pc);

% Jacobians of fromFrame C
[FCf,FCp] = fromFrameJac(cam,pc);

% Jacobians of fromFrame R
[FRf,FRp] = fromFrameJac(R,pr);

switch nargout
    case 4
        [GCw,GCs] = invPinHoleJac(pix,s,cam);
    case 5
        [GCw,GCs,GCcal] = invPinHoleJac(pix,s,cam);
        Gcal = FRp*FCp*GCcal;
    case 6
        [GCw,GCs,GCcal,GCundist] = invPinHoleJac(pix,s,cam);
        Gcal = FRp*FCp*GCcal;
        Gundist = FRp*FCp*GCundist;
end
       
    
% Output Jacobians
Gr = FRf;
Gc = FRp*FCf;
Gw = FRp*FCp*GCw;
Gs = FRp*FCp*GCs;
