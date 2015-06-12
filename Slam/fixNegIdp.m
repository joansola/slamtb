function Lmk = fixNegIdp(Lmk)

% FIXNEGIDP  Fix negative inverse/depth parameter.
%   LMK = FIXNEGIDP(Lmk) tests for negative inverse-depth parameters in
%   landmarks and sets them to a positive 0.001 if necessary.
%
%   See also CORRECTLMK.

%   (c) Joan Sola 2013

global Map

switch Lmk.type
    case {'idpPnt','ahmPnt'}
        if Map.x(Lmk.state.r(end)) < 0
            Map.x(Lmk.state.r(end)) = 0.001; % Fix lmk
        end
    case {'idpLin'}
        if any(Map.x(Lmk.state.r([6,9])) < 0)
            Map.x(Lmk.state.r([6,9])) = 0.001; % Fix lmk
        end
    case {'ahmLin'}
        if any(Map.x(Lmk.state.r([7,11])) < 0)
            Map.x(Lmk.state.r([7,11])) = 0.001; % Fix lmk
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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

