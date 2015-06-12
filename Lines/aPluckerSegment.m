function [s, S_l] = aPluckerSegment(l,t)

% APLUCKERSEGMENT  Anchored Plucker line's segment from abscissas.
%   APLUCKERSEGMENT(L,T) returns a 3d segment corresponding to the anchored
%   Plucker line L with endpoints defined by the abscissas T=[t1;t2].
%
%   [s, S_l] = ... returns the Jacobian wrt the line L.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

[pl,PL_l] = unanchorPlucker(l);
[s,S_pl]  = pluckerSegment(pl,t);
S_l       = S_pl*PL_l;



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

