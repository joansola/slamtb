function s = obj2segs(obj)

% OBJ2SEGS Get segments matrix from 3D object.
%   OBJ2SEGS(OBJ) returns a 3-by-N matrix of segments from the 3D
%   information in structure OBJ, stored in the N-by-3 matrix OBJ.vert,
%   with the object vertices, and the M-by-2 matrix OBJ.seg, with the
%   couples of indices in OBJ.vert defining each segment.
%
%   For example, the square:
%
%     1 +-----+ 2
%       |     |
%       |     |
%     3 +-----+ 4
%
%   is defined in OBJ as
%       OBJ.vert = [0 0 0; 1 0 0; 0 1 0; 1 1 0]
%       OBJ.seg  = [1 2; 2 4; 4 3; 3 1]
%   then the produced segments matrix SEG = OBJ2SEGS(OBJ) is
%       SEG = [ 0 1 1 0
%               0 0 1 1
%               0 0 0 0
%               1 1 0 0
%               0 1 1 0
%               0 0 0 0 ]

%   Copyright 2009 Joan Sola @ LAAS-CNRS.

p = obj2pnts(obj);    % endpoints in 3-by-N format
M = size(obj.seg,1);  % number of segments M
s = zeros(6,M);       % initialize output segments matrix

for i = 1:M  % for each segment ...
    
    j = obj.seg(i,1); % first endpoint's index
    k = obj.seg(i,2); % second endpoint's index
    s(:,i) = [p(:,j);p(:,k)]; % the segment!

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

