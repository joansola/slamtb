function [p,Phmg] = hmg2p(hmg)

% TODO
%
%

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


p0 = hmg(1:3,:);   % origin
r  = hmg(4,:);   % inverse depth

if size(hmg,2) == 1 % one only Idp

    p = p0*(1/r) ;

    if nargout > 1 % jacobians

        P_p0  = (1/r)*eye(3);
        P_r  = -p0/r^2;
        
        Phmg = [P_p0 P_r];

    end

else  % A matrix of Idps

%     v = py2vec(py);  % unity vector
%     p = x0 + v./repmat(r,3,1);
%     
%     if nargout > 1
        error('??? Jacobians not available for multiple landmarks.')
%     end

end



return

%% test jacobians

syms x y z rho
% TODO
