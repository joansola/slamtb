function [p, P_u, P_k, P_pol] = invOmniCam(u, k, pol)
%
% INVOMNICAM Inverse omnidirectional camera model
%   P = INVOMNICAM(U,S) gives the retroprojected point P of a pixel U at
%   depth S, from a omnidirectional camera
%   k   -> [xc yc c d e]    - "calibration" -> affine distortion in plane of pixels
%   pol -> [a0 a1 a2 a3 a4] - "distortion" polynom
%
%   based on M=cam2world(m, ocam_model) from DAVIDE SCARAMUZZA
%   "Omnidirectional camera calibration toolbox" CAM2WORLD Project a give
%   pixel point onto the unit sphere M=CAM2WORLD=(m, ocam_model) returns
%   the 3D coordinates of the vector emanating from the single effective
%   viewpoint on the unit sphere
%
%   
%   Author: Grigory Abuladze - email: ryhor.a@google.com
%
%   Last update May 2009
%   Author: Davide Scaramuzza - email: davide.scaramuzza@ieee.org

%   Copyright (C) 2012 Grigory Abuladze @ ASL-vision
%   Copyright (C) 2006 DAVIDE SCARAMUZZA   

  if nargout == 1  % only pixels
  
    u1 = depixelliseOmniCam(u, k);
    p  = omni_retro(u1, pol);
  
  else  % Jacobians

    if size(u,2) > 1
      error('Jacobians not available for multiple points');
    end
    
    [u1 U1_u U1_k] = depixelliseOmniCam(u, k);
    [p P_u1 P_pol] = omni_retro(u1, pol);
    
    P_u   = P_u1 * U1_u; 
    P_k   = P_u1 * U1_k;

  end
  

return 
%% Jacobian part - take a long, long, long long long time to compute.

syms a0 a1 a2 a3 a4 real
syms xc yc c d e real
syms u1 u2 s real

u   = [u1 u2]';
k   = [xc yc c d e];
pol = [a0 a1 a2 a3 a4]';

p     = invOmniCam(u, s, k, pol);

% P_u   = simplify(jacobian(p,u))
% P_s   = simplify(jacobian(p,s))
% P_k   = simplify(jacobian(p,k))
% P_pol = simplify(jacobian(p,pol))



%% test wrt original function



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

