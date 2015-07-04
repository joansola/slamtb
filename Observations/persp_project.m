function [u,Up] = persp_project(p)

% PERSP_PROJECT  Project point into plane using pin-hole camera model
%   U = PERSP_PROJECT(P) projects the point P into the image plane
%   situated at a focal distance of 1m. It also works for sets of points if
%   they are defined by the matrix P = [P1 ... Pn], with Pi = [xi;yi;zi].
%
%   [U,Up] = PERSP_PROJECT(P) returns the Jacobian wrt P. This only works
%   for single points, not for sets of points.
%
%   See also PINHOLE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

u = [p(1,:)./p(3,:) ; p(2,:)./p(3,:)];

if nargout > 1 % jacobians

    if size(p,2)>1
        error('Jacobians not possible for multiple points')
    else

        Up = [...
            [    1/p(3),      0, -p(1)/p(3)^2]
            [      0,    1/p(3), -p(2)/p(3)^2]];
    end
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

