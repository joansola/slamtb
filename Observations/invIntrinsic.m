function iK = invIntrinsic(k)

% INVINTRINSIC Build inverse intrinsic matrix

%   Copyright 2008-2014 Joan Sola @ LAAS-CNRS.

[u0, v0, au, av] = split(k);

% iK = [...
%     [   av,      0, -u0*av]
%     [    0,     au, -v0*au]
%     [    0,      0,  au*av]];

iK = [...
    [   1/au,        0, -u0/au]
    [      0,     1/av, -v0/av]
    [      0,        0,      1]];


return

%%
syms u0 v0 au av real
k = [u0 v0 au av]';
K = intrinsic(k);
iK = K^-1



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

