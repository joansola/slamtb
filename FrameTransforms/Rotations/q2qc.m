function [qc,QCq] = q2qc(q)

% Q2QC  Conjugate quaternion.
%   Q2QC(Q) for Q = [a  b  c  d] is the conjugate quaternion
%              QC = [a -b -c -d] corresponding to the inverse
%   rotation of that represented by Q.
%
%   [qc,QCq] = Q2QC(...) gives the Jacobian wrt Q.
%
%   See also QUATERNION, R2Q, Q2E, Q2V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



qc        = q;
qc(2:end) = -qc(2:end);

if nargout == 2
    QCq = diag([1 -1 -1 -1]);
end



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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

