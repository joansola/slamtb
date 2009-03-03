function [p,Pr,Pc,Pk,Pe,Pt] = homoInvRobCamPhotoPix(R,C,k,e,t)

% HOMOINVROBCAMPHOTO Inverse projection from camera in robot, in homog. coordinates.
%   HOMOINVROBCAMPHOTO(R,C,K,U,T) retroprojects the Euclidean pixel U from a
%   camera K in frame C, mounted on a robot R, using the homogeneous part
%   T. The result is a homogeneous point in projective space P3.
%   K is a vector of intrinsic parameters K = [u0 v0 au av]'; 
%   R and C are frames {R,C} = [x y z a b c d]';

if nargout == 1
    
    u = eu2hm(e);
    p = homoInvRobCamPhoto(R,C,k,u,t);
    
else % Jac -- OK
    
    [u,Ue]             = eu2hm(e);
    [p,Pr,Pc,Pk,Pu,Pt] = homoInvRobCamPhoto(R,C,k,u,t);
    
    Pe                 = Pu*Ue;
    
end

return

%%
syms xr yr zr ar br cr dr real
syms xc yc zc ac bc cc dc real
syms u1 u2 u3 t real
syms u0 v0 au av real

R=[xr yr zr ar br cr dr]';
C=[xc yc zc ac bc cc dc]';
k=[u0 v0 au av]';
u=[u1 u2]';

[p,Pr,Pc,Pk,Pu,Pt] = homoInvRobCamPhotoPix(R,C,k,u,t);

simplify(Pr-jacobian(p,R))
simplify(Pc-jacobian(p,C))
simplify(Pk-jacobian(p,k))
simplify(Pu-jacobian(p,u))
simplify(Pt-jacobian(p,t))
