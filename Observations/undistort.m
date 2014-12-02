function [up,UP_ud,UP_undist] = undistort(ud,unDist)

% UNDISTORT  Undistorts projected point with radial distortion.
%   UNDISTORT(UD,UNDIST) computes the position in the image plane of the
%   projected pixel corresponding to the distorted pixel UD. UNDIST is the
%   vector of distortion parameters. Undistortion is calculated with the
%   radial distortion model:
%
%     UP = UD * (1 + c2*r^2 + c4*r^4 + c6*r^6 + ...)
%
%   where    r^2 = UD(1)^2 + UD(2)^2
%     and UNDIST = [c2 c4 c6 ...]
%
%   [ud,UD_up,UD_undist] = UNDISTORT(...) returns Jacobians wrt UD and
%   UNDIST. UNDIST can be of any length.
%
%   See also INVPINHOLE.

%   Copyright 2006-2009 Joan Sola @ LAAS-CNRS.


n = length(unDist);

if n == 0
    up = ud;

    if (nargout > 1) && (size(up,2) == 1)
        UP_ud     = eye(2);
        UP_undist = zeros(2,0);
    end

else
    
    r2    = sum(ud.^2);
    nn    = 1:n;    % orders vector
    r2n   = r2.^nn; % powers vector
    ratio = 1 + r2n*unDist;

    up = ud.*[ratio;ratio];

    if nargout > 1 % jacobians

        dnn    = 2:2:2*n;
        dr2n   = r2.^(0:n-1);
        dratio = (dnn.*dr2n)*unDist;
        t      = dratio*ud;

        UP_ud = ratio*eye(2) + t*ud';

        UP_undist = kron(ud,r2n);

    end
end

return

%% Build jacobians up to order 3
% For higher orders:
%   1/ add c8,c10,c(2n)... to syms line below for an order n.
%   2/ add c8,c10,c(2n)... to vector unDist below for an order n.
%   3/ Execute this cell (Apple+return keys)
%   4/ Copy the results in UP_ud and UP_undist above, caring for the matrices'
%   opening and closing brackets (do not forget them).

syms u1 u2 c2 c4 c6 c8 real

ud = [u1;u2];
unDist = [c2;c4;c6;c8];

up   = undistort(ud,unDist);

UPud   = simple(jacobian(up,ud))
UPundist = simple(jacobian(up,unDist))


%% test jacobians
syms u1 u2 c2 c4 c6 c8 c10 real

ud = [u1;u2];
unDist = [c2;c4;c6;c8;c10];

[up,UPud,UPundist]   = undistort(ud,unDist);

simplify(UPud     - jacobian(up,ud))
simplify(UPundist - jacobian(up,unDist))



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

