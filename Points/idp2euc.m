function [p,P_idp] = idp2euc(idp)

% IDP2EUC  Inverse Depth to cartesian point conversion.
%   IDP2EUC(IDP) returns the cartesian 3D representation of the point coded
%   in Inverse depth.
%
%   IDP is a 6-vector : IDP = [x0 y0 z0 el az rho]' where
%       x0, z0, y0: anchor: the 3D point P0 where where distance is referred to.
%       el, az: azimuth and elevation of the ray through P that starts at P0.
%       rho: inverse of the distance from point P to P0.
%
%   [P,P_idp] = IDP2EUC(...) returns the Jacobian of the conversion wrt IDP.
%
%   See also p2idp.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

x0 = idp(1:3,:);   % origin
py = idp(4:5,:);   % pitch and roll
r  = idp(6,:);     % inverse depth

if size(idp,2) == 1 % one only Idp


    [v,V_py] = py2vec(py);  % unity vector

    p = x0 + v/r;

    if nargout > 1 % jacobians

        P_x  = eye(3);
        P_v  = eye(3)/r;
        P_r  = -v/r^2;

        P_py = P_v*V_py;

        P_idp = [P_x P_py P_r];

    end

else  % A matrix of Idps

    v = py2vec(py);  % unity vector
    p = x0 + v./repmat(r,3,1);
    
    if nargout > 1
        error('??? Jacobians not available for multiple landmarks.')
    end

end



return

%% test jacobians

syms x y z pitch yaw rho real
idp = [x;y;z;pitch;yaw;rho];
[p,P_idp] = idp2euc(idp);

P_idp - jacobian(p,idp) % it must return a matrix of zeros









