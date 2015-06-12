function [m,M_l] = seg2pvLin(l)

% SEG2PVLIN  Segment to point-vector line transform.
%   SEG2PVLIN(S) transforms the segment S=[P1;P2] to a point-vector line
%   [P1;V], where V is a (non-normalized) director vector of the line.
%
%   [pvl,PVL_ppl] = SEG2PVLIN(S) returns the Jacobian of the
%   transformation.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

m(1:3,1) = l(1:3);
m(4:6,1) = l(4:6)-l(1:3);

if nargout > 1
    
    M_l = [eye(3) zeros(3)
        -eye(3) eye(3)];
end

return

%% jac

syms l1 l2 l3 l4 l5 l6 real
l = [l1;l2;l3;l4;l5;l6];
[m,M_l] = pntsLine2pntVecLine(l);

simplify(M_l - jacobian(m,l))



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

