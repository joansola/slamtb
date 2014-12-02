function [it,ITt,ITq] = t2it(t,q)

% T2IT  Get translation vector of inverse transformation
%   IT = T2IT(T,Q) computes the translation vector corresponding to the
%   transformation inverse to (T,Q), i.e.:
%
%       IT = -R'*T
%
%   where R = q2R(Q)

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

Rt = q2R(q)';

it = -Rt*t;

if nargout > 1

    [a,b,c,d] = deal(q(1),q(2),q(3),q(4));
    [x,y,z] = deal(t(1),t(2),t(3));


    ITt = [...
        [ -a^2-b^2+c^2+d^2,     -2*b*c-2*a*d,     -2*b*d+2*a*c]
        [     -2*b*c+2*a*d, -a^2+b^2-c^2+d^2,     -2*c*d-2*a*b]
        [     -2*b*d-2*a*c,     -2*c*d+2*a*b, -a^2+b^2+c^2-d^2]];
    ITq = [...
        [ -2*a*x-2*d*y+2*c*z, -2*b*x-2*c*y-2*d*z,  2*c*x-2*b*y+2*a*z,  2*d*x-2*a*y-2*b*z]
        [  2*d*x-2*a*y-2*b*z, -2*c*x+2*b*y-2*a*z, -2*b*x-2*c*y-2*d*z,  2*a*x+2*d*y-2*c*z]
        [ -2*c*x+2*b*y-2*a*z, -2*d*x+2*a*y+2*b*z, -2*a*x-2*d*y+2*c*z, -2*b*x-2*c*y-2*d*z]];

end


return

%%

syms a b c d x y z real

t = [x;y;z];
q = [a;b;c;d];

it = t2it(t,q)

ITt = jacobian(it,t)
ITq = jacobian(it,q)



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

