function [w, W_v, W_q] = qRot(v,q)

% QROT Vector rotation via quaternion algebra.
%   W = QROT(V,Q) performs to vector V the rotation specified by
%   quaternion Q.
%
%   [w, W_v, W_q] = QROT(V,Q) returns Jacobians wrt V and Q. Note that
%   this only works with single points V = [x;y;z].
%
%   QROT is equivalent to Rp, with the exception that the arguments come in
%   different order.
%
%   See also QUATERNION, Q2Q, QPROD, RP, RTP.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

v0 = [0;v];

w = qProd(qProd(q,v0),q2qc(q));

w = w(2:end);

if nargout > 1 % we want Jacobians

    if size(v,2) == 1 % Jacobians are computed exactly as in function Rp.m.

        [a,b,c,d] = split(q);
        [x,y,z]   = split(v);

        sa = 2*(-b*x - c*y - d*z);
        sb = 2*( a*x - d*y + c*z);
        sc = 2*( d*x + a*y - b*z);
        sd = 2*(-c*x + b*y + a*z);

        W_q = [...
            [  sb, -sa,  sd, -sc]
            [  sc, -sd, -sa,  sb]
            [  sd,  sc, -sb, -sa]];

        W_v = q2R(q);
        
    else
        error('Jacobians only available for single points')
    end
end

return

%% BUILD AND TEST JACOBIANS

syms a b c d x y z real

q = [a;b;c;d];
p = [x;y;z];

[rp1,RPq1,RPp1] = Rp(q,p);
[rp,RPp,RPq]    = qRot(p,q);

RPq1 = simple(jacobian(rp,q));
RPp1 = simple(jacobian(rp,p));

ERPq = simplify(RPq-RPq1)
ERPp = simplify(RPp-RPp1)



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

