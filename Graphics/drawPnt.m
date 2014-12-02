function drawPnt(h,x,c)

% DRAWPNT  Draw 3D point with color.
%   DRAWPNT(H,X) Draw 2D or 3D point with handle H at position X.
%
%   DRAWPNT(H,X,C) uses color C.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if numel(x) == 2

    set(h,'xdata',x(1),'ydata',x(2),'vis','on')

elseif numel(x) == 3

    set(h,'xdata',x(1),'ydata',x(2),'zdata',x(3),'vis','on')

else

    error('??? Size of vector ''x'' not correct.')

end

if nargin == 3
    set(h,'color',c)
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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

