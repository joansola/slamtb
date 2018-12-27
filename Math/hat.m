function [SQ,SQw] = hat(W)

% HAT  Hat operator.
%   SQ = HAT(W) gives the skew symmetric matrix SQ corresponding
%   to the vector W defined by the 'hat' operator:
%
%        [ 0  -Wz  Wy]
%   SQ = [ Wz  0  -Wx]
%        [-Wy  Wx  0 ]
%
%   W = HAT(SQ) performs the inverse operation, i.e. gives the vector W so
%   that HAT(W) = SQ.
%   NOTE: The matrix SQ is NOT checked for skew-symmetry.
%
%   It is an error if length(W) ~= 3 or size(SQ) ~= [3 3].
%
%   See also ESSENTIAL.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


if numel(W) == 3 
    SQ = [...
        0     -W(3)  W(2)
        W(3)   0    -W(1)
        -W(2)  W(1)  0   ];

    if nargout > 1

        SQw = [...
            [  0,  0,  0]
            [  0,  0,  1]
            [  0, -1,  0]
            [  0,  0, -1]
            [  0,  0,  0]
            [  1,  0,  0]
            [  0,  1,  0]
            [ -1,  0,  0]
            [  0,  0,  0]];

    end

elseif numel(W) == 9 && size(W,1) == 3
%     SQ = [W(3,2);W(1,3);W(2,1)];
    SQ = W([6;7;2]);
else
    error('Input parameter W must be a 3x1 (or 1x3) vector, or a 3x3 matrix')
end

return

%%

syms x y z real
w = [x;y;z];
S = hat(w);
SQw = jacobian(S,w)



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

