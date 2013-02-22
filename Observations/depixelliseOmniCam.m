function [u,U_p,U_k] = depixelliseOmniCam(pix, k)
%
% TODO: can inverse A up front - will save calculation esp in Jac part
%
% DEPIXELLISEOMNICAM  - ocam Affine correction step - "backwards" - as in
% cam2world() ocam model 
%
%   DEPIXELLISEOMNICAM(U,K) maps the projected point U to the pixels matrix
%   defined by the camera calibration parameters k   = [xc yc c d e]; It
%   works with sets of pixels if they are defined by a matrix U = [U1 U2
%   ... Un] , where Ui = [ui;vi]
%
%   [p,Pu,Pk] = DEPIXELLISEOMNICAM(...) returns the jacobians wrt U and
%   K. This only works for single pixels U=[u;v], not for sets of pixels.
%
%   See also omniCam.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.
%
%   Copyright 2012 Grigory Abuladze @ ASL-vision.  ?
%   Author: Grigory Abuladze - email: ryhor.a@google.com

  n_points = size(pix,2);
  
  xc = k(1);
  yc = k(2);
  c  = k(3);
  d  = k(4);
  e  = k(5);

  % mind Davids [x y] -> [row col]
  A = [1 e;
       d c ];

  T = [xc;yc]*ones(1,n_points);
  u = A^-1*(pix-T);


  if nargout > 1 % jacobians
    
    if n_points > 1
      error('Jacobians not available for multiple points');
    end
    
    u1 = pix(1);
    u2 = pix(2);
    
    U_p = [...
            [  c/(c - d*e), -e/(c - d*e)]
            [ -d/(c - d*e),  1/(c - d*e)]
          ];

    U_k = [...
            [ -c/(c - d*e),  e/(c - d*e), (u1 - xc)/(c - d*e) - (c*(u1 - xc))/(c - d*e)^2 + (e*(u2 - yc))/(c - d*e)^2,                     (c*e*(u1 - xc))/(c - d*e)^2 - (e^2*(u2 - yc))/(c - d*e)^2, (c*d*(u1 - xc))/(c - d*e)^2 - (u2 - yc)/(c - d*e) - (d*e*(u2 - yc))/(c - d*e)^2]
            [  d/(c - d*e), -1/(c - d*e),                           (d*(u1 - xc))/(c - d*e)^2 - (u2 - yc)/(c - d*e)^2, (e*(u2 - yc))/(c - d*e)^2 - (u1 - xc)/(c - d*e) - (d*e*(u1 - xc))/(c - d*e)^2,                         (d*(u2 - yc))/(c - d*e)^2 - (d^2*(u1 - xc))/(c - d*e)^2]
          ];

  end

return

%% build jacobians

syms xc yc c d e real
syms u1 u2 real

pix = [u1;u2];
k   = [xc yc c d e];

u = depixelliseOmniCam(pix,k);

U_p = jacobian(u,pix)
U_k = jacobian(u,k)










