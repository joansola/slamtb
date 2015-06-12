function [s,d,S_k,S_si] = pinHoleSegment(k,si)

% PINHOLESEGMENT  Pin hole projection of a segment.
%   [S,D] = PINHOLESEGMENT(K,SI) projects into a pinhole camera with
%   intrinsic aprameters K the segment SI. It returns the projected segment
%   S and the non-observable depths D of the two endpoints.
%
%   SI is a 6-vector containing the two endpoints of the 3D segment.
%   S is a 4-vector conteining the two endpoints of the 2D segment.
%
%   SI can also be a 6-by-N matrix with N segments. In such case S is a
%   4-by-N matrix with N projected segments.
%
%   [S,D,S_k,S_si] = POINHOLESEGMENT(...) returns the Jacobians of S wrt K
%   and SI. It only works for single segments.
%
%   See also PINHOLE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

p1 = si(1:3,:);
p2 = si(4:6,:);

if nargout <= 2

    [e1,d1] = pinHole(p1,k);
    [e2,d2] = pinHole(p2,k);
    s       = [e1;e2];
    d       = [d1;d2];

else % Jacobians

    if size(si,2) == 1

        [e1,d1,E1_p1,E1_k] = pinHole(p1,k);
        [e2,d2,E2_p2,E2_k] = pinHole(p2,k);
        s       = [e1;e2];
        d       = [d1;d2];

        S_k = [...
            E1_k
            E2_k];

        Z23 = zeros(2,3);

        S_si = [...
            E1_p1 Z23
            Z23   E2_p2];

    else

        error('Jacobians not available for multiple segments.')

    end

end

return

%% test
syms p1 p2 p3 q1 q2 q3 u0 v0 au av real
k  = [u0;v0;au;av];
si = [p1;p2;p3;q1;q2;q3];

[s,d,S_k,S_si] = pinHoleSegment(k,si);

simplify(S_k - jacobian(s,k))
simplify(S_si - jacobian(s,si))



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

