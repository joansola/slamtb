function [qn,QNq] = normquat(q)

% NORMQUAT Normalize quaternion to unit length
%   NORMQUAT(Q) returns a unit length quaternion Q/norm(Q)
%
%   [qn,QNq] = NORMQUAT(Q) returns also the Jacobian wrt Q. Note that this
%   Jacobian is a symmetric 4x4 matrix.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


nq = sqrt(q(:)'*q(:));
qn = q/nq;


if nargout > 1
    
    a = q(1);
    b = q(2);
    c = q(3);
    d = q(4);

    nq3 = nq^3;
    
    QNq = [...
        [ (b^2+c^2+d^2)/nq3,          -a/nq3*b,          -a/nq3*c,          -a/nq3*d]
        [          -a/nq3*b, (a^2+c^2+d^2)/nq3,          -b/nq3*c,          -b/nq3*d]
        [          -a/nq3*c,          -b/nq3*c, (a^2+b^2+d^2)/nq3,          -c/nq3*d]
        [          -a/nq3*d,          -b/nq3*d,          -c/nq3*d, (a^2+b^2+c^2)/nq3]];
end
return

%%

syms a b c d real
q = [a;b;c;d];
[qn,QNq] = normquat(q);

QNq - simple(jacobian(qn,q))

QNq - QNq'



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

