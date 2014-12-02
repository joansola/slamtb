function [hm,HMrt] = rt2hmgLin(rt)

% RT2HMGLIN  Rho-theta to homogeneous line conversion.
%   RT2HMGLIN(RT) transforms the line RT=[rho;theta] into a homogeneous
%   line [a;b;c]. A homogeneous line is such that ax+by+c = 0 for any point
%   [x;y] of the line. For homogeneous points [x;y;t] we have ax+by+ct = 0.
%
%   [hm, HM_rt] = RT2HMGLIN(...) returns the Jacobian matrix.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

rho   = rt(1);
theta = rt(2);

a = cos(theta);
b = sin(theta);
c = -rho;

hm = [a;b;c];

if nargout > 1

    HMrt = [...
        [  0, -b]
        [  0,  a]
        [ -1,  0]];

end

return


%%

syms rho theta real

rt = [rho;theta];

[hm,HMrt] = rt2hmgLin(rt)

HMrt - jacobian(hm,rt)



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

