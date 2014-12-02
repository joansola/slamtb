function inSq = inSquare(data,sq,m)

% INSQUARE  Points inside square.
%   INSQUARE(DATA,SQ) returns TRUE for those points in point
%   matrix DATA that are inside a rectangle SQ.
%
%   INSQUARE(DATA,SQ,MARGIN) considers a point inside the
%   rectangle if it is further than MARGIN units from its
%   borders.
%
%   SQ is defined by its limits as SQ = [xmin xmax ymin ymax].
%
%   DATA is a 2D-points matrix : DATA = [P1 ... PN] ,
%   with Pi = [xi;yi].

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 3
    inSq = (data(1,:) >= sq(1)) & ...
        (data(1,:) <= sq(2)) & ...
        (data(2,:) >= sq(3)) & ...
        (data(2,:) <= sq(4));
else
        inSq = (data(1,:) >= sq(1) + m) & ...
        (data(1,:) <= sq(2) - m) & ...
        (data(2,:) >= sq(3) + m) & ...
        (data(2,:) <= sq(4) - m);
end


return

%%

all(data>=sq([1 3])')
all(data<=sq([2 4])')
all(data>=sq([1 3])') && all(data<=sq([2 4])')



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

