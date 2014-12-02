function [l,Lp,Lq] = pp2hmgLin(p,q)

% PP2HMGLIN  Homogeneous line from two homogeneous points
%   PP2HMGLIN(P,Q) is the homogeneous line in the projective plane joining the
%   two  points P and Q. P and Q can be either Euclidean 2-points or
%   homogeneous 3-points.
%
%   [L,Lp,Lq] = PP2HMGLIN(p,q) returns the Jacobians wrt P and Q.
%
%   See also CROSSJ, HH2P.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout == 1
    if numel(p) == 2 % Support for Euclidean points
        p = euc2hmg(p);
        q = euc2hmg(q);
    end
    l = cross(p,q);
else
    if numel(p) == 2 % Support for Euclidean points
        [p,Pp] = euc2hmg(p);
        [q,Qq] = euc2hmg(q);
        [l,Lp,Lq] = crossJ(p,q);
        Lp = Lp*Pp;
        Lq = Lq*Qq;
    else
        [l,Lp,Lq] = crossJ(p,q);
    end
end

return

%% Jac
syms p1 p2 p3 q1 q2 q3 real

%% Euclidean
p=[p1;p2];
q=[q1;q2];
[l,Lp,Lq]=pp2hmgLin(p,q);
Lp-jacobian(l,p)
Lq-jacobian(l,q)

%% Homogeneous
p=[p1;p2;p3];
q=[q1;q2;q3];
[l,Lp,Lq]=pp2hmgLin(p,q);
Lp-jacobian(l,p)
Lq-jacobian(l,q)



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

