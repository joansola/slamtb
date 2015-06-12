function Omega=w2omega(w)

% W2OMEGA  Skew symetric matrix OMEGA from angular rates vector W.
%   OMEGA = W2OMEGA(W) builds OMEGA as
%
%      Omega=[  0   -W(1) -W(2) -W(3)
%              W(1)   0    W(3) -W(2)
%              W(2) -W(3)   0    W(1)
%              W(3)  W(2) -W(1)   0  ];
%
%   See also Q2PI, ODO3.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

 

if all(size(w) == [3 1])
    Omega=[  0   -w(1) -w(2) -w(3)
            w(1)   0    w(3) -w(2)
            w(2) -w(3)   0    w(1)
            w(3)  w(2) -w(1)   0  ];
else
    error('Input dimensions don''t agree. Enter 3x1 column vector')
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

