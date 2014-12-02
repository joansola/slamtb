function s = satColor(c)

% SATCOLOR  Saturate color.
%   SATCOLOR(C) returns a color specification which corresponds to the
%   saturated version of input color C. 
%
%   For CHAR colors, C(1) in 'rgbcmybw', the output is unchanged as all
%   Matlab colors specified by CHAR are already saturated. Only the first
%   character of C is evaluated.
%
%   For vector colors C = [R G B], saturation is achieved by bringing the
%   minimum component to zero and the maximum to one. If all components are
%   equal (C is gray-level) the output is [0 0 0] (black) or [1 1 1]
%   (white) depending on the gray level MEAN(C) being greater than 0.5 or
%   not.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if isnumeric(c)

    if (numel(c) == 3)  % color is a 3-vector

        if all(c==max(c))  % color is gray. bring to black or white
            s = ones(size(c))*(max(c)>.5);

        else % color is not gray. Saturate.
            cz = c - min(c);   % bring to zero
            s  = cz / max(cz); % stretch to one

        end
    else

        error('??? Invalid color specification.')

    end

elseif ischar(c)

    c = c(1); % take first letter

    if any(c == 'rgbcmybw') % valid colors. See DOC COLORSPEC.

        s = c;              % valid char colors are already saturated.

    else

        error('??? Invalid color specification.')

    end

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

