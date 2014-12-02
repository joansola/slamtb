function [qp,QP_ep] = epose2qpose(ep)

% EPOSE2QPOSE  Euler-specified to quaternion-specified pose conversion.
%
%   QP = EPOSE2QPOSE(EP) returns a full 7-pose QP=[X;Q] from a full 6-pose
%   QE=[X;E], where X is 3D opsition and Q and E are 3D orientations.
%
%   [QP,Jep] = EPOSE2QPOSE(...) returns also the Jacobian matrix
%
%   See also QPOSE2EPOSE, EULERANGLES, QUATERNION, FRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if any(size(ep) ~= [6,1])
    warning('Input Euler-pose should be a column 6-vector')
end

qp            = zeros(7,1);  % empty quaternion pose
qp(1:3)       = ep(1:3);     % position copy
P             = eye(3);      % Jacobian of copy function
[qp(4:7),Q_e] = e2q(ep(4:6));% orientation and Jacobian

QP_ep         = [P zeros(3);zeros(4,3) Q_e]; % Full Jacobian



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

