function [ep,EPq] = qpose2epose(qp)

% QPOSE2EPOSE  Quaternion-specified to Euler-specified pose conversion.
%
%   EP = QPOSE2EPOSE(QP) returns a full 6-pose EP=[X;E] from a full 7-pose
%   QP=[X;Q] where X is 3D opsition and Q and E are 3D orientations.
%
%   [EP,Jqp] = QPOSE2EPOSE(...) returns also the Jacobian matrix.
%
%   See also EPOSE2QPOSE, EULERANGLES, QUATERNION, FRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if any(size(qp) ~= [7,1])
    warning('Input pose should be a column 7-vector')
end

ep = zeros(6,1);
ep(1:3) = qp(1:3);
P = eye(3);
[ep(4:6),Eq] = q2e(qp(4:7));
EPq = [P zeros(3,4);zeros(3) Eq];



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

