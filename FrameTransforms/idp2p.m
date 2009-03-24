function [p,Pidp] = idp2p(idp)

% IDP2P  Inverse Depth to cartesian point conversion.
%   IDP2P(IDP) returns the cartesian 3D representation of the point coded
%   in Inverse depth.
%
%   IDP is a 6-vector : IDP = [x0 y0 z0 el az rho]' where
%       x0, z0, y0: anchor: the 3D point P0 where where distance is referred to.
%       el, az: azimuth and elevation of the ray through P that starts at P0.
%       rho: inverse of the distance from point P to P0.
%
%   [P,P_idp] = IDP2P(...) returns the Jacobian of the conversion wrt IDP.
%
%   See also p2idp.


x0 = idp(1:3,:);   % origin
py = idp(4:5,:);   % pitch and roll
r  = idp(6,:);     % inverse depth

if size(idp,2) == 1 % one only Idp
    

    [v,Vpy] = py2vec(py);  % unity vector

    p = x0 + v/r;

    if nargout > 1 % jacobians

        Px  = eye(3);
        Pv  = eye(3)/r;
        Pr  = -v/r^2;

        Ppy = Pv*Vpy;

        Pidp = [Px Ppy Pr];

    end

else  % A matrix of Idps
    
    v = py2vec(py);  % unity vector

    p = x0 + v./repmat(r,3,1);
    
end    

    

return

%% test jacobians

syms x y z pitch yaw rho real
idp = [x;y;z;pitch;yaw;rho];
[p,Pidp] = idp2p(idp);

Pidp - jacobian(p,idp) % it must return a matrix of zeros
