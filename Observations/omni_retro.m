function [p P_u P_pol] = omni_retro(u, pol)
% 
% OMNI_RETRO  Retroproject pixel into 3D space.
%   P = OMNI_RETRO(UP, pol) retro-projects the point UP of the image
%   plane into the point P at depth S in 3D space
%
%   based on M=cam2world(m, ocam_model) from DAVIDE SCARAMUZZA
%   "Omnidirectional camera calibration toolbox" CAM2WORLD Project a give
%   pixel point onto the unit sphere M=CAM2WORLD=(m, ocam_model) returns
%   the 3D coordinates of the vector emanating from the single effective
%   viewpoint on the unit sphere
%
%
% Notes
% - pol: polynom coeff (vec)  -> "distortion" parametes in a0..an order, not polyval() order
%                                 we have 4th order polynome 
%
%   Author: Davide Scaramuzza - email: davide.scaramuzza@ieee.org
%   Author: Grigory Abuladze - email: ryhor.a@google.com

%   Copyright (C) 2012 Grigory Abuladze @ ASL-vision. 
%   Copyright (C) 2008 DAVIDE SCARAMUZZA, ETH Zurich  

  if nargout == 1  % only points
    % Given an image point it returns the 3D coordinates of its correspondent optical ray  
    r = (u(1,:).^2 + u(2,:).^2).^0.5;
    p = [u(1,:);
         u(2,:);
         polyval(pol(end:-1:1), r)];
    p = normc(p); % normalizes coordinates so that they have unit length (projection onto the unit sphere)     

  else %  nargout > 2  ->  Jacobians
  
    if size(u,2) > 1
      error('Jacobians not available for multiple points');
    end
    
    r   = (u(1)^2 + u(2)^2)^0.5;
    n   = numel(pol);
    nn  = 0:n-1;     % orders vector
    r2n = r.^nn;     % powers vector
    p3  = r2n*pol;   % 
    p   = [u(1);
           u(2);
           p3];
    
    [p,P_p] = normvec(p,1);
        
    a0 = pol(1); a1 = pol(2); a2 = pol(3); a3 = pol(4); a4 = pol(5);
    u1 = u(1);
    u2 = u(2);
    r2 = (u1^2 + u2^2);
    r  = r2^(1/2);
       
    % all before normalization 
    P_u = [...
            [                                            1,                                            0]
            [                                            0,                                            1]
            [ 2*a2*u1 + 4*a4*u1*r2 + (a1*u1)/r + 3*a3*u1*r, 2*a2*u2 + 4*a4*u2*r2 + (a1*u2)/r + 3*a3*u2*r]
          ];

    P_pol = [...
              [ 0, 0,  0,        0,    0]
              [ 0, 0,  0,        0,    0]
              [ 1, r, r2, r2^(3/2), r2^2]
            ];

    % add normalization
    % f = norm(g()) -> use chain rule
    P_u = P_p * P_u;

  
  end

return


%% Jacobian
syms a0 a1 a2 a3 a4 real
syms u1 u2 s real


u   = [u1 u2]';
pol = [a0 a1 a2 a3 a4]';

p     = omni_retro(u, s, pol);

P_u   = simplify(jacobian(p,u))
P_s   = simplify(jacobian(p,s))
P_pol = simplify(jacobian(p,pol))



