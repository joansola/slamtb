function Frm = createFrames(Rob, Trj)

% CREATEFRAMES  Create Frm structure array.
%   Frm = CREATEFRAMES(Rob,Trj) creates the structure array Frm() to be
%   used as SLAM data. 
%
%   State and manifold data allocations are fixed for each position in the
%   window. Range information for the storage of this data is defined here
%   and should never be modified.

%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.

for rob = [Rob.rob]
        
    for frm = 1:Trj(rob).maxLength
        
        Frm(rob,frm).frm         = frm;
        Frm(rob,frm).id          = [];
        Frm(rob,frm).used        = false;
        
        Frm(rob,frm).rob         = rob;
        Frm(rob,frm).factors     = [];
        
        Frm(rob,frm).state.x     = zeros(Rob(rob).state.size,1);
        Frm(rob,frm).state.dx    = zeros(Rob(rob).state.dsize,1);
        Frm(rob,frm).state.r     = [];
        Frm(rob,frm).state.size  = Rob(rob).state.size;
        Frm(rob,frm).state.dsize = Rob(rob).state.dsize;
        Frm(rob,frm).state.M     = []; % Jacobian of projection to manifold
        
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

