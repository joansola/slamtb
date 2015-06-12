function [hh,HH_hm,HH_s] = hms2hh(hm,seg)

% HMS2HH  Orthogonal endpoints innovation for homogeneous line and segment.
%   HMS2HH(HM,SEG) is a 2-vector with the orthogonal distances from the two
%   extremes of the segment SEG to the homogeneous line HM.
%
%   [HH,HH_hm,HH_s] = ... returns the Jacobians wrt HM and SEG.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

p = seg(1:2);
q = seg(3:4);

if nargout == 1

    hp = lp2d(hm,p);
    hq = lp2d(hm,q);

    hh = [hp;hq];

else

    [hp,HP_hm,HP_p] = lp2d(hm,p);
    [hq,HQ_hm,HQ_q] = lp2d(hm,q);

    hh = [hp;hq];

    Z = zeros(1,2);

    HH_hm = [HP_hm;HQ_hm];
    HH_s  = [HP_p Z;Z HQ_q];

end

return

%% jac

syms a b c u1 u2 v1 v2 real
hm = [a;b;c];
seg = [u1;v1;u2;v2];

[hh,HH_hm,HH_s] = hms2hh(hm,seg)

simplify(HH_hm - jacobian(hh,hm))
simplify(HH_s - jacobian(hh,seg))



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

