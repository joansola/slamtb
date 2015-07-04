function r = ranges(Str)

% RANGES Get ranges from structure array.
%   RANGES(Str) Get ranges collected from all ranges in structure array
%   Str. 
%
%   In general, Str is a structure array Str(:,:) with at least a
%   field Str.state.r, where the range of positions in the state vector is
%   stored.
%
%   In particular, Str is one of the following structures in SLAMTB or
%   SLAMTB_GRAPH:
%
%       Rob: a 1-dimensional array of robots 
%       Sen: a 1-D array of sensors
%       Lmk: a 1-D array of landmarks
%       Frm: a 2-D array of frames.
%   
%   In any case, the output is a column vector of indices to the storage
%   vector in the Map, that is, Map.x, so that,
%
%       Map.x(ranges(Str)) 
%
%   returns all the state values of all the elements in the structure array
%   Str. Likewise, and as a particular example,
%
%       Map.H(ranges(Lmk),ranges(Lmk)) 
%
%   returns the Hessian matrix belonging to the landmark states, while
%
%       Map.H(ranges(Frm),ranges(Lmk))
%
%   returns the Hessian block with states linking frames and landmarks.
%   This might be useful to retrieve all states of a given kind, for
%   example for its use in partitioning the Hessian matrix before taking
%   the Schur complement.
%
%   See also NEWRANGE, BLOCKRANGE, FREESPACE.

%   Copyright 2015-   Joan Sola @ IRI-CSIC-UPC


states = [Str.state];
r = [states.r];
r = r(:);




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

