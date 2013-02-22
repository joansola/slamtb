function [seg, t] = retroProjAplEndPnts(Rob,Sen,Lmk,Obs)

% RETROPROJAPLENDPNTS  Retro project anchored Plucker endpoints.
%   [SEG,T] = RETROPROJAPLENDPNTS(Rob,Sen,Lmk,Obs) retroprojects the
%   segment endpoints in Bos.meas.y onto the anchored Plucker line Lmk.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


global Map

% Plucker line
al  = Map.x(Lmk.state.r);
l   = unanchorPlucker(al);

% rays in sensor frame
r1s = pix2PluckerRay(Sen.par.k,Obs.meas.y(1:2));
r2s = pix2PluckerRay(Sen.par.k,Obs.meas.y(3:4));

% rays in world frame
r1  = fromFramePlucker(Rob.frame,fromFramePlucker(Sen.frame,r1s));
r2  = fromFramePlucker(Rob.frame,fromFramePlucker(Sen.frame,r2s));

% endpoints and abscissas
[e1,t1] = intersectPlucker(l,r1);
[e2,t2] = intersectPlucker(l,r2);

% build segment and abscissas vector
if t2 > t1
    seg = [e1;e2];
    t   = [t1;t2];
else
    seg = [e2;e1];
    t   = [t2;t1];
end









