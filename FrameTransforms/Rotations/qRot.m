function [vr, VR_v, VR_q] = qRot(v,q)

% QROT Vector rotation via quaternion algebra.
%   PR = QROT(V,Q) performs to vector V the rotation specified by
%   quaternion Q.
%
%   See also QUATERNION, Q2Q, QPROD.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

v0 = [0;v];

vr = qProd(qProd(q,v0),q2qc(q));

vr = vr(2:end);

if nargout > 1 % we want Jacobians

    if size(v,2) == 1

        [a,b,c,d] = split(q);
        [x,y,z]   = split(v);

        axdycz = 2*(a*x - d*y + c*z);
        bxcydz = 2*(b*x + c*y + d*z);
        cxbyaz = 2*(c*x - b*y - a*z);
        dxaybz = 2*(d*x + a*y - b*z);

        VR_q = [...
            [  axdycz,  bxcydz, -cxbyaz, -dxaybz]
            [  dxaybz,  cxbyaz,  bxcydz,  axdycz]
            [ -cxbyaz,  dxaybz, -axdycz,  bxcydz]];

        VR_v = q2R(q);
        
    else
        error('Jacobians only available for single points')
    end
end

%%
return
%% BUILD AND TEST JACOBIANS

syms a b c d x y z real

q = [a;b;c;d];
p = [x;y;z];

[rp1,RPq1,RPp1] = Rp(q,p);
[rp,RPp,RPq] = qRot(p,q);

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

%   SLAMTB is Copyright 2007, 2008, 2009, 2010, 2011, 2012 
%   by Joan Sola @ LAAS-CNRS.
%   SLAMTB is Copyright 2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

