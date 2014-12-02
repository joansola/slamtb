function [ud,UD_up,UD_dist] = distort(up,dist)

% DISTORT  Distort projected point with radial distortion.
%   DISTORT(UP,DIST) computes the position in the image plane of the
%   distorted pixel corresponding to the projected pixel UP. DIST is the
%   vector of distortion parameters. Distortion is calculated with the
%   radial distortion model:
%
%     UD = UP * (1 + k2*r^2 + k4*r^4 + k6*r^6 + ...)
%
%   where r^2  = UP(1)^2 + UP(2)^2
%     and DIST = [k4 k4 k6 ...]
%
%   [ud,UD_up,UD_dist] = DISTORT(...) returns Jacobians wrt UP and DIST.
%
%   See also PINHOLE.
%

%   FIXME: RMAX works not so nice
%   DISTORT(...,RMAX) accepts the maximum image radius to limit the effect
%   of distortion to the image plane. The image radius is one half of the
%   image diagonal. In case norm(UP) > RMAX then UD = RMAX/norm(UP)*UP. The
%   Jacobians are trivially computed just for argument consistency: UDup =
%   eye(2) and UDdist = zeros(2,length(dist)).

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

r2 = sum(up.^2);

n = length(dist);

if n == 0  % No distortion
    ud = up;

    if size(up,2) == 1
        UD_up   = eye(2);
        UD_dist = zeros(2,0);
    else
        error('??? Jacobians not available for multiple points.')
    end
    
    
else       % Distortion

    if size(up,2) == 1   % One only pixel

        nn    = 1:n;           % orders vector
        r2n   = r2.^nn;        % powers vector
        ratio = 1 + r2n*dist;  % distortion ratio
        
        ud    = ratio*up;

        if nargout > 1 % jacobians

            dnn    = 2:2:2*n;
            dr2n   = r2.^(0:n-1);
            dratio = (dnn.*dr2n)*dist;

            UD_up = ratio*eye(2) + dratio*(up*up');

            UD_dist = kron(up,r2n);
        end
        
    else  % vectorized operation for multiple pixels.

        ratio = ones(size(r2));
        for i=1:n
            ratio = ratio + dist(i)*r2.^i;
        end

        ud = up.*[ratio;ratio];

        if nargout > 1 % jacobians

            error('??? Jacobians not available for multiple points.')

        end
    end
end



return

%% Build jacobians up to order 3
% For higher orders:
%   1/ add k8,k10,k(2n)... to syms line below for an order n.
%   2/ add k8,k10,k(2n)... to vector dist below for an order n.
%   3/ Execute this cell (Apple+return keys)
%   4/ Copy the results in UDup and UDdist above, caring for the matrices'
%   opening and closing brackets (do not forget them).

syms u1 u2 k2 k4 k6 k8 real
up   = [u1;u2];
dist = [k2;k4;k6;k8];
ud   = distort(up,dist);

UDup   = simple(jacobian(ud,up))
UDdist = simple(jacobian(ud,dist))

%% test

[ud, UD_up, UD_dist] = distort(up,dist);

simplify(UD_up - jacobian(ud,up))
simplify(UD_dist - jacobian(ud,dist))



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

