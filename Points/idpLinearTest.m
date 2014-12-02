function Ld = idpLinearTest(Rob,Sen,Lmk)

% IDPLINEARTEST  Linearity test of cartesian point given inverse depth point
%   LD = IDPLINEARTEST(ROB,SEN,LMK) return a value with the result of the
%   linearity test.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.
%   Copyright 2009 David Marquez @ LAAS-CNRS.

global Map

ir = Lmk.state.r;

% explode idp:
idp = Map.x(ir);
py  = idp(4:5);
m   = py2vec(py);
rho = idp(6);

% and idp variance:
IDP = Map.P(ir,ir);
RHO = IDP(6,6);

xi  = idp2euc(idp);
rwc = fromFrame(Rob.frame,Sen.frame.t); % current camera center

hw        = xi-rwc;  % idp point to camera center
sigma_rho = sqrt(RHO);
sigma_d   = sigma_rho/rho^2; % depth sigma
d1        = norm(hw);
cos_a     = m'*hw/d1;

Ld = 4*sigma_d/d1*abs(cos_a);



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

