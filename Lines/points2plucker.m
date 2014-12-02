function [L,La,Lb] = points2plucker(A,B)

% POINTS2PLUCKER  Plucker line from two homogeneous points
%   L = POINTS2PLUCKER(A,B) is the Plucker line that passes over two points
%   A and B. The points are specified by their homogeneous coordinates
%   [x;y;z;w]. 
%
%   The result is a Plucker line expressed as a 6-vector. This vector can
%   be decomosed as L = [a;b], where the 3-vectors a and b admit the
%   following interpretation:
%
%   *   a - is a vector normal to the plane that contains the line and the
%       origin of coordinates.
%
%   *   b - is a vector director of the line, which lies on the plane
%       above.
%
%   *   a and b are orthogonal, i.e. dot(a,b)=0.
%
%   *   the distance from the line to the origin is given by
%       norm(a)/norm(b).
%
%   [L,La,Lb] = ... returns the Jacobians wrt A and B.
%
%   See also PLANES2PLUCKER.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


L = [cross(A(1:3),B(1:3));A(4)*B(1:3)-B(4)*A(1:3)];

if nargout > 1

    [a1,a2,a3,a4] = split(A);
    [b1,b2,b3,b4] = split(B);

    La = [...
        [   0,  b3, -b2,   0]
        [ -b3,   0,  b1,   0]
        [  b2, -b1,   0,   0]
        [ -b4,   0,   0,  b1]
        [   0, -b4,   0,  b2]
        [   0,   0, -b4,  b3]];

    Lb = [...
        [   0, -a3,  a2,   0]
        [  a3,   0, -a1,   0]
        [ -a2,  a1,   0,   0]
        [  a4,   0,   0, -a1]
        [   0,  a4,   0, -a2]
        [   0,   0,  a4, -a3]];
end


return

%% jac

syms a1 a2 a3 a4 b1 b2 b3 b4 p1 p2 p3 p4 q1 q2 q3 q4 real
A=[a1;a2;a3;a4];
B=[b1;b2;b3;b4];
L=points2plucker(A,B)

La = jacobian(L,A)
Lb = jacobian(L,B)



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

