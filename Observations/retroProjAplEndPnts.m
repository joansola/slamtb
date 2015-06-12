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

