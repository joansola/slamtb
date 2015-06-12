function drawEllipse(h, x, P, c, ns, NP)

% DRAWELLIPSE Draw 2D ellipse or 3D ellipsoid.
%   DRAWELLIPSE(H,X,P) redraws ellipse or ellipsoid in handle H with mean X
%   and covariance P.
%
%   DRAWELLIPSE(...,C) allows the specification of the ellipse color C. If
%   C is not given or is empty, the color is unchanged.
%
%   DRAWELLIPSE(...,C,NS,NP) allows entering the number of sigmas NS and
%   the number of points NP. The default values are NS=3 and NP=10. Use
%   C=[] if you do not want to modify the ellipse color.

%   Copyright 2009 Joan Sola @ LAAS-CNRS.

if nargin < 6,         NP = 10;
    if nargin < 5,     ns = 3;
    end
end

if numel(x) == 2

    [X,Y] = cov2elli(x,P,ns,NP);
    set(h,'xdata',X,'ydata',Y,'vis','on')
    
elseif numel(x) == 3
    
    [X,Y,Z] = cov3elli(x,P,ns,NP);
    set(h,'xdata',X,'ydata',Y,'zdata',Z,'vis','on')
    
else
    error('??? Size of vector ''x'' not correct.')
end

if nargin > 3 && ~isempty(c)
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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

