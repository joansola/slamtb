function E = essential(f)

%  ESSENTIAL Essential matrix from frame specification.
%   ESSENTIAL(F) returns the essential matrix of the pair of uncalibrated
%   cameras related by a frame transformation F.
%
%   F is either a 7-vector F=[t;q] or a frame structure with at least the
%   fields F.t and F.Rt updated. Use F=updateFrame(F) prior to your call to
%   ESSENTIAL if unsure about the state of these fields.
%
%   The essential matrix E is defined as:
%       E = R' * hat(t) = F.Rt * hat(F.t)
%
%   See also FUNDAMENTAL, FRAME, UPDATEFRAME.

%   (c) Joan Sola 2014

[t, ~, ~, Rt] = splitFrame(f);

E = Rt * hat(t);


return

%% Tests

t = rand(3,1);
q = normvec(rand(4,1));
f.x = [t;q];
f = updateFrame(f);

E = essential(f);

t1 = rand(3,1);
q1 = normvec(rand(4,1));
f1.x = [t1;q1];
f1 = updateFrame(f1);

t2 = rand(3,1);
q2 = normvec(rand(4,1));
f2.x = [t2;q2];
f2 = updateFrame(f2);

E1 = essential(f1);
E2 = essential(f2);

% relative from f1 to f2
f3 = composeFrames(invertFrame(f1),f2);
E3 = essential(f3);

E3_alg = E2*f1.R + (E1*f2.R)';

E3_test = abs(E3_alg - E3) > 1e-15

% now for fundamental matrices
K1 = intrinsic(rand(4,1));
K2 = intrinsic(rand(4,1));
K1i = K1^-1;
K2i = K2^-1;

F3 = K2i' * E3 * K1i;

F3_alg = K2i' * E2 * f1.R * K1i  +  (K1i' * E1 * f2.R * K2i)';
F3_test = abs(F3_alg - F3) > 1e-14



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

