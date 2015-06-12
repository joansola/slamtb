function [rt,RTp,RTq] = pp2rt(p,q)

% PP2RT  Points to rho theta 2D line conversion.
%   PP2RT(P,Q) is the rho-theta line in the plane joining the
%   two  points P and Q. P and Q can be either Euclidean 2-points or
%   homogeneous 3-points.
%  
%   [rt,RTp,RTq] = POINTS2RT(p,q) returns the Jacobians wrt P and Q.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout == 1
    
    rt = hm2rt(pp2hm(p,q));
    
else
    
    [l,Lp,Lq] = pp2hm(p,q);
    [rt,RTl]  = hm2rt(l);
    RTp = RTl*Lp;
    RTq = RTl*Lq;
    
end

return

%%

syms p1 p2 p3 q1 q2 q3 real

% Euclidean
p = [p1;p2];
q = [q1;q2];
[rt,RT_p,RT_q] = points2rt(p,q)

simplify(RT_p - jacobian(rt,p))
simplify(RT_q - jacobian(rt,q))



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

