function [seg, t] = retroProjPlkEndPnts(Rob,Sen,Lmk,Obs)

% RETROPROJPLKENDPNTS  Retro project Plucker endpoints.
%   [SEG,T] = RETROPROJPLKENDPNTS(Rob,Sen,Lmk,Obs)

global Map

% rays in sensor frame
r1s = pix2PluckerRay(Sen.par.k,Obs.meas.y(1:2));
r2s = pix2PluckerRay(Sen.par.k,Obs.meas.y(3:4));

% rays in world frame
r1 = fromFramePlucker(Rob.frame,fromFramePlucker(Sen.frame,r1s));
r2 = fromFramePlucker(Rob.frame,fromFramePlucker(Sen.frame,r2s));

% Plucker line
l = Map.x(Lmk.state.r);

% endpoints and abscissas
[e1,t1] = intersectPlucker(l,r1);
[e2,t2] = intersectPlucker(l,r2);

% build segment and abscissas vector
seg = [e1;e2];
t   = [t1;t2];

