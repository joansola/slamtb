function [s, S_l] = hmgLin2seg(l)

%   HMGLIN2SEG HMG line to segment conversion
%   HMGLIN2SEG  returns a 3d segment with the two suppor points of the HMG
%   line L.
%
%   [s, S_l] = IDPLIN2SEG(L) returns the Jacobian wrt L.

%   Copyright 2009 Teresa Vidal.

if nargout == 1

    [e1, e2] = hmgLin2hmgPnts(l);
    p1       = hmg2euc(e1);
    p2       = hmg2euc(e2);

    s        = [p1;p2];

else

    [e1, e2, E1_l, E2_l] = hmgLin2hmgPnts(l);
    [p1, P1_e1]          = hmg2euc(e1);
    [p2, P2_e2]          = hmg2euc(e2);
    
    s   = [p1;p2];
    S_l = [P1_e1*E1_l ; P2_e2*E2_l];

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

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

