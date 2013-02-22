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










