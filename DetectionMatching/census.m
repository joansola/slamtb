function sc = census(I,J)

% CENSUS  Census Correlation coefficient
%   CENSUS(I,J) computes the census score of matrices I and J:
%
%     CENSUS = 1/N * ~xor( I > Io , J > Jo )
%
%   where N  = prod(size(I))
%         Io = I(central pixel)
%         Jo = J(central pixel)
%   and   size(I) = size(J)
%
%   See also PATCHCORR, ZNCC, SSD

% (c) 2005 Joan Sola


if size(I) ~= size(J)
    error ('Matrices must be the same size.')
else
    s = size(I); % patch size
    if any(iseven(s))
        error('Matrix sizes must be odd.')
    else
        c = (s+1)/2; % patch center
        i = I(c(1),c(2)); % central pixel
        j = J(c(1),c(2)); % central pixel

        V = I > i;
        W = J > j;

        SC = ~xor(V,W);
        sc = sum(sum(SC))/numel(I);
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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

