function MapFig = drawLmk(MapFig,Lmk,MapOpt)

% DRAWLMK  Draw 3D landmark.
%   DRAWLMK(MapFig,Lmk) draws 3D landmark Lmk into the map figure by
%   updating the handles in MapFig structure. It accepts different types of
%   landmark by checking the field Lmk.type. Supported landmark types
%   (June 2009) are:
%       'idpPnt' - inverse depth points
%       'eucPnt' - Euclidean points
%       'hmgPnt' - homogeneous points.
%
%   DRAWLMK(...) draws mean and covariances of landmarks: 
%     - For punctual landmarks, the mean is a dot and the covariance is the
%       3/sigma ellipsoid. 
%     - For line landmarks, the mean is a segment between the two
%       landmark's endpoints, and the covariance is a 3-sigma ellipsoind at
%       each one of these endpoints.
%
%   See also DRAWIDPPNT, DRAWEUCPNT, DRAWHMGPNT.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch (Lmk.type)

    % landmark types
    % --------------
    case {'idpPnt'}
        colors = MapOpt.colors.othPnt;
        drawIdpPnt(MapFig, Lmk, colors, MapOpt);

    case {'eucPnt'}
        colors = MapOpt.colors.defPnt;
        drawEucPnt(MapFig, Lmk, colors, MapOpt);

    case {'hmgPnt'}
        colors = MapOpt.colors.othPnt;
        drawHmgPnt(MapFig, Lmk, colors, MapOpt);
        
    case {'ahmPnt'}
        colors = MapOpt.colors.othPnt;
        drawAhmPnt(MapFig, Lmk, colors, MapOpt);
        
    case {'plkLin'}
        colors = MapOpt.colors.othLin;
        drawPlkLin(MapFig, Lmk, colors, MapOpt);
        
    case {'aplLin'}
        colors = MapOpt.colors.othLin;
        drawAplLin(MapFig, Lmk, colors, MapOpt);
        
    case 'idpLin'
        colors = MapOpt.colors.othLin;
        drawIdpLin(MapFig, Lmk, colors, MapOpt);

    case {'hmgLin'}
        colors = MapOpt.colors.othLin;
        drawHmgLin(MapFig, Lmk, colors, MapOpt);

    case {'ahmLin'}
        colors = MapOpt.colors.othLin;
        drawAhmLin(MapFig, Lmk, colors, MapOpt);
        
    otherwise
        % TODO : print an error and go out
        error('??? Unknown landmark type ''%s''.',Lmk.type);

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

