function [pix,PIXu,PIXk] = pixelliseOmniCam(u,k)

% PIXELLISEOMNICAM Omnicam Affine correction step
%   PIXELLISEOMNICAM(U,K) maps the projected point U to the pixels matrix defined
%   by the camera calibration parameters k   = [xc yc c d e]; It works with
%   sets of pixels if they are defined by a matrix U = [U1 U2 ... Un] ,
%   where Ui = [ui;vi]
%
%   [p,Pu,Pk] = PIXELLISEOMNICAM(...) returns the jacobians wrt U and K.
%   This only works for single pixels U=[u;v], not for sets of pixels.
%
%   See also OMNICAM.

%   Copyright 2012 Grigory Abuladze @ ASL-vision.  
%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

  xc  = k(1); 
  yc  = k(2); 
  c   = k(3);
  d   = k(4);
  e   = k(5);
  
  %"mind David's [x y]->[row col] notation 
  pix(1,:) = u(1,:)   + u(2,:)*e  + xc; %
  pix(2,:) = u(1,:)*d + u(2,:)*c  + yc; %
  
  if nargout > 1 % jacobians
    PIXu = [...
              [ 1, e]
              [ d, c]
            ];
    PIXk = [...
              [ 1, 0,  0,    0,  u(2)]
              [ 0, 1, u(2), u(1),  0 ]
           ];

  end

return

%% build jacobians

syms xc yc c d e real
syms u1 u2 real

u = [u1;u2];
k = [xc yc c d e];

pix = pixelliseOmniCam(u,k);

PIXu = jacobian(pix,u)
PIXk = jacobian(pix,k)



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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

