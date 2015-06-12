function [Frm] = createFrames(Rob, Opt)

% CREATEFRAMES  Create Frm structure array.
%   Frm = CREATEFRAMES(Frame) creates the structure array Frm() to be
%   used as SLAM data. The input Frame{}  is a cell array of structures
%   as specified by the user in userData.m. There must be one Frame{}
%   per each frame type considered. See userData.m for details.
%
%   State and manifold data allocations are fixed for each position in the
%   window. Range information for the storage of this data is defined here
%   and should never be modified.

%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.

stateSize = Rob.state.size;
maniSize = Rob.manifold.size;

for frm = 1:Opt.map.numFrames

    Frm(frm).frm = frm;
    Frm(frm).id = [];
    Frm(frm).used = false;
    Frm(frm).rob = [];

    Frm(frm).factorIds = [];
    
    Frm(frm).state.x = [];
    Frm(frm).state.r = (1 + (frm-1)*stateSize : frm*stateSize);
    Frm(frm).state.size = stateSize;
    
    Frm(frm).manifold.x = [];
    Frm(frm).manifold.active = false;
    Frm(frm).manifold.r = (1 + (frm-1)*maniSize : frm*maniSize);
    Frm(frm).manifold.size = maniSize;
    
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

