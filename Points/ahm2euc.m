function [p,P_ahm] = ahm2euc(ahm)

% AHM2EUC  Inverse Depth to cartesian point conversion.
%   AHM2EUC(AHM) returns the cartesian 3D representation of the point coded
%   in Anchored Homogeneous (AHP).
%
%   AHM is a t-vector : AHM = [x0 y0 z0 u v w rho]' where
%       x0, z0, y0: anchor: the 3D point P0 where where distance is referred to.
%       u, v, w: director vector of the ray through P that starts at P0.
%       rho: inverse of the distance from point P to P0.
%
%   [P,P_ahm] = AHM2EUC(...) returns the Jacobian of the conversion wrt AHM.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

x0 = ahm(1:3,:);   % origin
v  = ahm(4:6,:);   % vector
r  = ahm(7,:);     % inverse distance

if size(ahm,2) == 1 % one only Idp


    p = x0 + v/r;

    if nargout > 1 % jacobians

        P_x  = eye(3);
        P_v  = eye(3)/r;
        P_r  = -v/r^2;

        P_ahm = [P_x P_v P_r];

    end

else  % A matrix of Idps

    p = x0 + v./repmat(r,3,1);
    
    if nargout > 1
        error('??? Jacobians not available for multiple landmarks.')
    end

end



return

%% test jacobians

syms x y z u v w rho real
ahm = [x;y;z;u;v;w;rho];
[p,P_ahm] = ahm2euc(ahm);

P_ahm - jacobian(p,ahm) % it must return a matrix of zeros



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

