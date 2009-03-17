function [p,Pidp] = idp2p(idp)

% IDP2P  Inverse Depth to cartesian point conversion.
%   IDP2P(IDP) returns the cartesian 3D representation of the point coded
%   in Inverse depth.
%
%   IDP is a 6-vector : IDP = [xi yi zi el az rho]' where
%       xi, zi, yi: is the 3D point Pi where where distance is referred to.
%       el, az: azimuth and elevation of the ray that starts at Pi.
%       rho: inverse of the point's distance to Pi.
%
%   [P,Pidp] = IDP2P(...) returns the Jacobian of the conversion wrt IDP.


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
