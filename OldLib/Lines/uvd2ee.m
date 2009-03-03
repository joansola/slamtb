function [eL,eR,EL_uvd,ER_uvd] = uvd2ee(uvd)

% UVD2EE  Stereo pixel to left and right pixels.
%   [eL,eR] = UVD2EE(UVD) gives left and right pixels corresopnding to the
%   stereo pixel UVD = [u,v,d].
%
%   [eL,eR,EL_uvd,ER_uvd] = ... returns the Jacobians wrt UVD.

% (c) 2008 Joan Sola @ LAAS-CNRS.

eL = uvd(1:2);
eR = eL - [uvd(3);0];

if nargout > 1
    
    EL_uvd = [...
        1 0 0
        0 1 0];
    
    ER_uvd = [...
        1 0 -1
        0 1 0];
    
end