function [uu,Up,Uc] = depixellise(pix,cal)

% DEPIXELLISE  Pixellic to metric conversion
%   DEPIXELLISE(PIX,CAL) returns the metric coordinates of an image pixel
%   PIX given camera intrinsic parameters CAL = [u0 v0 au av]'
%
%   [u,Up,Uc] = DEPIXELLISE(...) gives the jacobians wrt PIX and CAL.
%
%   See also INVPINHOLE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

u0 = cal(1);
v0 = cal(2);
au = cal(3);
av = cal(4);

u = pix(1,:);
v = pix(2,:);

uu = [(u-u0)/au
    (v-v0)/av];

if nargout > 1
    Up = [...
        [ 1/au,    0]
        [    0, 1/av]];
    Uc = [...
        [        -1/au,            0, (-u+u0)/au^2,            0]
        [            0,        -1/av,            0, (-v+v0)/av^2]];
end

return

%% jacobians test

syms u0 v0 au av u v real
pix = [u;v];
cal = [u0;v0;au;av];

[u,Up,Uc] = depixellise(pix,cal);

simplify(Up - jacobian(u,pix))
simplify(Uc - jacobian(u,cal))



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

