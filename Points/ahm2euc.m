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









