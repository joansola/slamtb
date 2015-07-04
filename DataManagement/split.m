function varargout = split(A)

% SPLIT  Split vectors into scalars, or matrices into row vectors.
%   [s1,s2,...,sn] = SPLIT(V), with V a vector, returns all its components
%   in scalars s1 ... sn. It is an error if numel(V) < nargout.
%
%   [v1,...,vn] = SPLIT(M), with M a matrix, returns its rows as separate
%   vectors v1 ... vn. It is an error if size(M,2) < nargout.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if isvector(A)
    % A is vector. We take row or column.
    ni = length(A);
    if nargout > ni
        error('not enough components in input vector');
    else
        for i = 1:nargout
            varargout{i} = A(i);
        end
    end
else
    % A is matrix. We split rows only.
    ni = size(A,2);
    if nargout > ni
        error('not enough rows in input matrix');
    else
        for i = 1:nargout
            varargout{i} = A(i,:);
        end
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

