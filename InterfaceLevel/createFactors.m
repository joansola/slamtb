function Fac = createFactors(Opt)

% CREATEFACTORS  Create Fac structure array.
%   Fac = CREATEFACTORS(Opt) creates the structure array Fac() to be
%   used as SLAM data. All data is obtained from options structure Opt. See
%   userData for details.

%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.

% Compute max nbr of factors based on general options
numFactors = Opt.map.numFrames*(2 + Opt.correct.nUpdates + Opt.init.nbrInits(2)) + Opt.init.nbrInits(1);

% Create all factor structures
for fac = 1:numFactors
 
    Fac(fac).fac       = fac; % index in Fac array
    Fac(fac).id        = []; % Factor unique ID
    Fac(fac).used      = false; % Factor is being used ?
    Fac(fac).type      = ''; % {'motion','measurement','absolute'}
    Fac(fac).rob       = []; % rob index
    Fac(fac).sen       = []; % sen index
    Fac(fac).lmk       = []; % lmk index
    Fac(fac).frames    = []; % Frames (one or more)
    Fac(fac).state.r1  = [];
    Fac(fac).state.r2  = [];
    Fac(fac).meas.y    = [];
    Fac(fac).meas.R    = [];
    Fac(fac).meas.W    = []; % measurement information matrix
    Fac(fac).exp.e     = []; % expectation
    Fac(fac).exp.E     = []; % expectation cov
    Fac(fac).exp.W     = []; % expectation information matrix
    Fac(fac).err.z     = []; % error or innovation (we call it error because we are on graph SLAM)
    Fac(fac).err.Z     = []; % error cov matrix
    Fac(fac).err.W     = []; % error information matrix
    Fac(fac).err.Wsqrt = []; % square root of error information matrix
    Fac(fac).err.J1    = []; % Jac. of error wrt. node 1
    Fac(fac).err.J2    = []; % Jac. of error wrt. node 2
    Fac(fac).err.size  = 0;  % Size of error vector
    
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

