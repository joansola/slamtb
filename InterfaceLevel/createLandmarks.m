function Lmk = createLandmarks(Opt)

% CREATELANDMARKS  Create Lmk structure array.
%   Lmk = CREATELANDMARKS(Landmark) creates the structure array Lmk() to be
%   used as SLAM data. The input Landmark{}  is a cell array of structures
%   as specified by the user in userData.m. There must be one Landmark{}
%   per each landmark type considered. See userData.m for details.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

for lmk = 1:Opt.map.numLmks

    Lmk(lmk).lmk     = lmk;
    Lmk(lmk).id      = [];
    Lmk(lmk).type    = '';
    Lmk(lmk).used    = false;
    Lmk(lmk).factors = []; % factors list

    % Landmark state
    [ lmkSize, lmkDSize] = lmkSizes( Opt.init.initType, Opt.map.type);
    Lmk(lmk).state.x = zeros(lmkSize(1),1);
    Lmk(lmk).state.r = [];
    Lmk(lmk).state.size  = lmkSize(1);
    Lmk(lmk).state.dsize = lmkDSize(1);
    Lmk(lmk).state.M = []; % Jacobian of projection to manifold
    
    % Landmark descriptor or signature
    Lmk(lmk).sig     = [];

    % other parameters out of the SLAM map
    Lmk(lmk).par     = [];
    switch Opt.init.initType
        case 'idpPnt'
            Lmk(lmk).par.anchorrob  = [];
            Lmk(lmk).par.anchorsen  = [];
            Lmk(lmk).par.anchorfrm  = [];
            Lmk(lmk).par.anchorfac  = [];
            Lmk(lmk).par.anchormeas = [];
            Lmk(lmk).par.priorfac   = [];
        case 'papPnt'
            Lmk(lmk).par.mainrob  = [];
            Lmk(lmk).par.mainsen  = [];
            Lmk(lmk).par.mainfrm  = [];
            Lmk(lmk).par.mainfac  = [];
            Lmk(lmk).par.mainmeas = [];
            Lmk(lmk).par.assorob  = [];
            Lmk(lmk).par.assosen  = [];
            Lmk(lmk).par.assofrm  = [];
            Lmk(lmk).par.assofac  = [];
            Lmk(lmk).par.assomeas = [];
    end
    
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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

