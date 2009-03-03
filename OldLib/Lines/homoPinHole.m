function [u,s,Uk,Up] = homoPinHole(k,p)

% HOMOPINHOLE Inverse pin-hole projection in homogeneous coordinates
%   HOMOPINHOLE(K,P) projects homogeneous point P to a pin-hole camera
%   with intrinsic parameters K = [u0 v0 au av]'.
%
%   [U,S] = ... returns also the point's depth S wrt the camera plane
%
%   [U,S,Uk,Up] = ... returns the Jacobians wrt K and P.

K = intrinsic(k);

u = K*p(1:3);
s = p(3)/p(4);

if nargout > 1 % Jac -- OK

    Uk = [...
        [ p(3),  0  , p(1),  0  ]
        [  0  , p(3),  0  , p(2)]
        [  0  ,  0  ,  0  ,  0  ]];
    Up = [K [0;0;0]];

end

return

%%
syms p1 p2 p3 p4 real
syms u0 v0 au av real

k=[u0 v0 au av]';
p=[p1 p2 p3 p4]';

[u,s,Uk,Up] = homoPinHole(k,p);

simplify(Uk-jacobian(u,k))
simplify(Up-jacobian(u,p))
