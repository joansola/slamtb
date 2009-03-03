function [e,s,Er,Ec,Ek,Ep] = homoRobCamPhotoPix(R,C,k,p)

% HOMOROBCAMPHOTOPIX Projection to camera in robot, in homog. coordinates.
%   HOMOROBCAMPHOTOPIX(R,C,K,U,T) projects the homogeneous point P to a
%   camera K in frame C, mounted on a robot R, producing a non-homogeneous
%   pixel U.
%   K is a vector of intrinsic parameters K = [u0 v0 au av]';
%   R and C are frames {R,C} = [x y z a b c d]';
%
%   [E,S] = ... returns the depth S of the point in camera frame.
%
%   [e,s,Er,Ec,Ek,Ep] = ... returns Jacobians wrt R, C, K, and T.

if nargout == 1

    [u,s] = homoRobCamPhoto(R,C,k,p);
    e = hm2eu(u);

else % Jac -- OK

    [u,s,Ur,Uc,Uk,Up] = homoRobCamPhoto(R,C,k,p);
    [e,Eu] = hm2eu(u);

    Er = Eu*Ur;
    Ec = Eu*Uc;
    Ek = Eu*Uk;
    Ep = Eu*Up;

end

return

%% Jac

syms xr yr zr ar br cr dr real
syms xc yc zc ac bc cc dc real
syms p1 p2 p3 p4 real
syms u0 v0 au av real

R=[xr yr zr ar br cr dr]';
C=[xc yc zc ac bc cc dc]';
k=[u0 v0 au av]';
p=[p1 p2 p3 p4]';

[u,Ur,Uc,Uk,Up] = homoRobCamPhotoPix(R,C,k,p);

simplify(Ur-jacobian(u,R))
simplify(Uc-jacobian(u,C))
simplify(Uk-jacobian(u,k))
simplify(Up-jacobian(u,p))
