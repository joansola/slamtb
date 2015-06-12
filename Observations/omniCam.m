function [u s U_p U_k U_pol] = omniCam(p, k, pol)
% 
% OMNICAM Gives projected pixel u of 3D point p for Omnidirectional Camera model
%
%   based on WORLD2CAM() from DAVIDE SCARAMUZZA "Omnidirectional camera
%   calibration toolbox" m=WORLD2CAM_FAST(M, ocam_model) projects a 3D
%   point on to the image and returns the pixel coordinates. This function
%   uses an approximation of the inverse polynomial to compute the
%   reprojected point. Therefore it is very fast.
%   
%   M is a 3xN matrix containing the coordinates of the 3D points:
%   M=[X;Y;Z] "ocam_model" contains the model of the calibrated camera.
%   m=[rows;cols] is a 2xN matrix containing the returned rows and columns
%   of the points after being reproject onto the image.
%
%
% - k:   [xc yc c d e]        -> "calibration" -> affine distortion in plane of pixels
% - pol: polynom coeff (vec)  -> "distortion" parametes in a0..an order, not polyval() order
%                                 we have 10th order polynome 
% return:
% - u: pixel
% - s: unmeasurable depth from the camera center.
%
%   Author: Grigory Abuladze - email: ryhor.a@google.com
%   Author: Davide Scaramuzza - email: davide.scaramuzza@ieee.org

%   Copyright (C) 2012 Grigory Abuladze @ ASL-vision. 
%   Copyright (C) 2008 DAVIDE SCARAMUZZA, ETH Zurich  

  % Point's depth
  s = p(3,:);

  if nargout < 3  % 
  
    u  = pixelliseOmniCam( omni_project(p, pol), k);

  else  % Jacobians
  
    if size(p,2) > 1
      error('Jacobians not available for multiple points');
    end

    [u1 U1_p  U1_pol] = omni_project(p, pol);
    [u, U_u1, U_k]    = pixelliseOmniCam(u1, k);

    U_p   = U_u1*U1_p;
    U_pol = U_u1*U1_pol;
        
  end
  

return


%% Jacobian
syms a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 real
syms xc yc c d e real
syms x y z real

p   = [x y z]';
k   = [xc yc c d e];
pol = [a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10]';

[u s U_p U_k U_pol] = omniCam(p, k, pol);
simplify(U_p   - jacobian(u,p))
simplify(U_k   - jacobian(u,k))
simplify(U_pol - jacobian(u,pol))



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

