function drawRawLines(SenFig,Raw)

% DRAWRAWLINES  Draw raw lines.
%   DRAWRAWLINES(SENFIG,RAW)  redraws the 2D segments in RAW on figure
%   SenFig.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if ~isempty(Raw.data.segments.coord)
    
    m = size(Raw.data.segments.coord,2); % number of segments
    pn = {'xdata','ydata'};
    pv = mat2cell(Raw.data.segments.coord([1 3 2 4],:)',ones(1,m),[2 2]);
    
    set(SenFig.raw.segments(1:m),...
        pn,     pv,...
        'vis',  'on')
    set(SenFig.raw.segments(m+1:end),...
        'vis',  'off')
    
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

