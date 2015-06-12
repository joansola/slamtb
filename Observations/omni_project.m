function [u U_p U_pol] = omni_project(p, pol)
% 
% OMNI_PROJECT Gives projected pixel u of 3D point p for Omnidirectional Camera model
%
%   based on WORLD2CAM_FAST from DAVIDE SCARAMUZZA "Omnidirectional camera
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
%   Author: Davide Scaramuzza - email: davide.scaramuzza@ieee.org
%   Author: Grigory Abuladze - email: ryhor.a@google.com
%
% - pol: polynom coeff (vec)  -> "distortion" parametes in a0..an order, not polyval() order
%                                 we have 10th order polynome 
% return:
% - u: pixel
%

%   Copyright (C) 2012 Grigory Abuladze @ ASL-vision.  
%   Copyright (C) 2008 DAVIDE SCARAMUZZA, ETH Zurich  


  % pixel(s)
  NORM            = (p(1,:).^2 + p(2,:).^2).^0.5;
  NORM(NORM == 0) = eps; %these are the scene points which are along the z-axis. This will avoid division by ZERO later 
  theta           = atan( p(3,:)./NORM );

  if size(p,2) > 1
    rho = polyval( pol(end:-1:1) , theta ); %Distance in pixel of the reprojected points from the image center
  else
    n   = numel(pol);
    nn  = 0:n-1;        % orders vector
    t2n = theta.^nn;    % powers vector
    rho = t2n*pol;      % polynom -> Distance in pixel of the reprojected points from the image center
  end
  
  u(1,:) = p(1,:)./NORM.*rho ;
  u(2,:) = p(2,:)./NORM.*rho ;

  if nargout > 2  % Jacobians
  
    if size(p,2) > 1
      error('Jacobians not available for multiple points');
    end
    
    x = p(1);
    y = p(2);
    z = p(3);
  
    a0 = pol(1); a1 = pol(2); a2 = pol(3); a3 = pol(4); a4 = pol(5);
    a5 = pol(6); a6 = pol(7); a7 = pol(8); a8 = pol(9); a9 = pol(10); a10 = pol(11);
    
    at = atan(z/(x^2 + y^2)^(1/2));
    
    U_p   = [...
              [ (a0 + a1*at + a2*at^2 + a3*at^3 + a4*at^4 + a5*at^5 + a6*at^6 + a7*at^7 + a8*at^8 + a9*at^9 + a10*at^10)/(x^2 + y^2)^(1/2) - (x*((a1*x*z)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (2*a2*x*z*at)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (3*a3*x*z*at^2)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (4*a4*x*z*at^3)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (5*a5*x*z*at^4)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (6*a6*x*z*at^5)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (7*a7*x*z*at^6)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (8*a8*x*z*at^7)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (9*a9*x*z*at^8)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (10*a10*x*z*at^9)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2))))/(x^2 + y^2)^(1/2) - (x^2*(a0 + a1*at + a2*at^2 + a3*at^3 + a4*at^4 + a5*at^5 + a6*at^6 + a7*at^7 + a8*at^8 + a9*at^9 + a10*at^10))/(x^2 + y^2)^(3/2),                                                                                                                                                                                                                                                                                                                                                                  - (x*((a1*y*z)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (2*a2*y*z*at)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (3*a3*y*z*at^2)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (4*a4*y*z*at^3)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (5*a5*y*z*at^4)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (6*a6*y*z*at^5)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (7*a7*y*z*at^6)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (8*a8*y*z*at^7)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (9*a9*y*z*at^8)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (10*a10*y*z*at^9)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2))))/(x^2 + y^2)^(1/2) - (x*y*(a0 + a1*at + a2*at^2 + a3*at^3 + a4*at^4 + a5*at^5 + a6*at^6 + a7*at^7 + a8*at^8 + a9*at^9 + a10*at^10))/(x^2 + y^2)^(3/2), (x*(a1 + 2*a2*at + 3*a3*at^2 + 4*a4*at^3 + 5*a5*at^4 + 6*a6*at^5 + 7*a7*at^6 + 8*a8*at^7 + 9*a9*at^8 + 10*a10*at^9))/(x^2 + y^2 + z^2)]
              [                                                                                                                                                                                                                                                                                                                                                                  - (y*((a1*x*z)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (2*a2*x*z*at)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (3*a3*x*z*at^2)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (4*a4*x*z*at^3)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (5*a5*x*z*at^4)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (6*a6*x*z*at^5)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (7*a7*x*z*at^6)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (8*a8*x*z*at^7)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (9*a9*x*z*at^8)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (10*a10*x*z*at^9)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2))))/(x^2 + y^2)^(1/2) - (x*y*(a0 + a1*at + a2*at^2 + a3*at^3 + a4*at^4 + a5*at^5 + a6*at^6 + a7*at^7 + a8*at^8 + a9*at^9 + a10*at^10))/(x^2 + y^2)^(3/2), (a0 + a1*at + a2*at^2 + a3*at^3 + a4*at^4 + a5*at^5 + a6*at^6 + a7*at^7 + a8*at^8 + a9*at^9 + a10*at^10)/(x^2 + y^2)^(1/2) - (y^2*(a0 + a1*at + a2*at^2 + a3*at^3 + a4*at^4 + a5*at^5 + a6*at^6 + a7*at^7 + a8*at^8 + a9*at^9 + a10*at^10))/(x^2 + y^2)^(3/2) - (y*((a1*y*z)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (2*a2*y*z*at)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (3*a3*y*z*at^2)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (4*a4*y*z*at^3)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (5*a5*y*z*at^4)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (6*a6*y*z*at^5)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (7*a7*y*z*at^6)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (8*a8*y*z*at^7)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (9*a9*y*z*at^8)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2)) + (10*a10*y*z*at^9)/((z^2/(x^2 + y^2) + 1)*(x^2 + y^2)^(3/2))))/(x^2 + y^2)^(1/2), (y*(a1 + 2*a2*at + 3*a3*at^2 + 4*a4*at^3 + 5*a5*at^4 + 6*a6*at^5 + 7*a7*at^6 + 8*a8*at^7 + 9*a9*at^8 + 10*a10*at^9))/(x^2 + y^2 + z^2)]
            ];
          
    U_pol = [...
              [ x/(x^2 + y^2)^(1/2), (x*at)/(x^2 + y^2)^(1/2), (x*at^2)/(x^2 + y^2)^(1/2), (x*at^3)/(x^2 + y^2)^(1/2), (x*at^4)/(x^2 + y^2)^(1/2), (x*at^5)/(x^2 + y^2)^(1/2), (x*at^6)/(x^2 + y^2)^(1/2), (x*at^7)/(x^2 + y^2)^(1/2), (x*at^8)/(x^2 + y^2)^(1/2), (x*at^9)/(x^2 + y^2)^(1/2), (x*at^10)/(x^2 + y^2)^(1/2)]
              [ y/(x^2 + y^2)^(1/2), (y*at)/(x^2 + y^2)^(1/2), (y*at^2)/(x^2 + y^2)^(1/2), (y*at^3)/(x^2 + y^2)^(1/2), (y*at^4)/(x^2 + y^2)^(1/2), (y*at^5)/(x^2 + y^2)^(1/2), (y*at^6)/(x^2 + y^2)^(1/2), (y*at^7)/(x^2 + y^2)^(1/2), (y*at^8)/(x^2 + y^2)^(1/2), (y*at^9)/(x^2 + y^2)^(1/2), (y*at^10)/(x^2 + y^2)^(1/2)]
            ];    
  end
  

return


%% Jacobian
syms a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 real
syms x y z real


p   = [x y z]';
pol = [a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10]';

u     = omni_project(p, pol);
U_p   = simplify(jacobian(u,p))
U_pol = simplify(jacobian(u,pol))



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

