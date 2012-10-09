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



