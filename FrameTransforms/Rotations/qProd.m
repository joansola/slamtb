function [q,Qq1,Qq2] = qProd(q1,q2)

% QPROD Quaternion product.
%   QPROD(Q1,Q2) is the quaternion product Q1 * Q2
%
%   [Q,Qq1,Qq2] = QPROD(...) gives the Jacobians wrt Q1 and Q2.
%
%   See also QUATERNION, QROT, R2Q, Q2E, Q2V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


q = [...
    q1(1)*q2(1) - q1(2)*q2(2) - q1(3)*q2(3) - q1(4)*q2(4)
    q1(1)*q2(2) + q1(2)*q2(1) + q1(3)*q2(4) - q1(4)*q2(3)
    q1(1)*q2(3) - q1(2)*q2(4) + q1(3)*q2(1) + q1(4)*q2(2)
    q1(1)*q2(4) + q1(2)*q2(3) - q1(3)*q2(2) + q1(4)*q2(1)];

if nargout > 1
    Qq1 = [...
        [  q2(1), -q2(2), -q2(3), -q2(4)]
        [  q2(2),  q2(1),  q2(4), -q2(3)]
        [  q2(3), -q2(4),  q2(1),  q2(2)]
        [  q2(4),  q2(3), -q2(2),  q2(1)]];

    Qq2 = [...
        [  q1(1), -q1(2), -q1(3), -q1(4)]
        [  q1(2),  q1(1), -q1(4),  q1(3)]
        [  q1(3),  q1(4),  q1(1), -q1(2)]
        [  q1(4), -q1(3),  q1(2),  q1(1)]];
end

return

%%
syms a b c d w x y z real
q1 = [a b c d]';
q2 = [w x y z]';

[q,Qq1,Qq2] = qProd(q1,q2);

simplify(Qq1 - jacobian(q,q1))
simplify(Qq2 - jacobian(q,q2))



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

