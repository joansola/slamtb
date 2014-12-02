function Lmk = createLandmarks(Opt)

% CREATELANDMARKS  Create Lmk structure array.
%   Lmk = CREATELANDMARKS(Landmark) creates the structure array Lmk() to be
%   used as SLAM data. The input Landmark{}  is a cell array of structures
%   as specified by the user in userData.m. There must be one Landmark{}
%   per each landmark type considered. See userData.m for details.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

for lmk = 1:Opt.map.numLmks

    Lmk(lmk).lmk  = lmk;
    Lmk(lmk).id   = [];
    Lmk(lmk).type = '';
    Lmk(lmk).used = false;

    % Landmark state range in Map
    Lmk(lmk).state.r = [];

    % Landmark descriptor or signature
    Lmk(lmk).sig = [];

    % other parameters out of the SLAM map
    Lmk(lmk).par = [];

    % Lmk management counters
    Lmk(lmk).nSearch = 0;  % number of times searched
    Lmk(lmk).nMatch  = 0;  % number of times matched
    Lmk(lmk).nInlier = 0;  % number of times declared inlier

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

