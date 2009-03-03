function [GRf,GRw,GRs,GRcal,GRundist] = ...
    invCamPhotoJac(cam,pix,s)

% INVCAMPHOTOJAC Jacobians of INVCAMPHOTO
%   [GRf,GRw,GRs] = INVCAMPHOTOJAC(CAM,PIX,S) gives the
%   Jacobians of INVCAMPHOTO evaluated for a camera
%   CAM at pixel PIX and depth S. CAM is a structure with
%   camera frame CAM.X and calibration parameters CAM.cal.
%     GRc is the Jac. wrt camera pose
%     GRw is the Jac. wrt pixel
%     GRs is the Jac. wrt depth
%
%   Frame X must be specified in a vector containing:
%     translation vector t
%     orientation quaternion q
%
%   [GRf,GRw,GRs,GRcal,GRundist] = INVCAMPHOTOJAC(...) gives also
%   the Jacobian wrt the calibration parameters of the camera
%   CAM.cal and the undistortion parameters CAM.undist


% retroprojected point in camera frame
pc = invPinHole(pix,s,cam);

% Jacobians of fromFrame C
[FCf,FCp] = fromFrameJac(cam,pc);

switch nargout
    case 3
        [GCw,GCs] = invPinHoleJac(pix,s,cam);
    case 4
        [GCw,GCs,GCcal] = invPinHoleJac(pix,s,cam);
        GRcal = FCp*GCcal;
    case 5
        [GCw,GCs,GCcal,GCundist] = invPinHoleJac(pix,s,cam);
        GRcal    = FCp*GCcal;
        GRundist = FCp*GCundist;
end

% Output Jacobians
GRf = FCf;
GRw = FCp*GCw;
GRs = FCp*GCs;

