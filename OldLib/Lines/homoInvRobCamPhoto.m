function [p,Pr,Pc,Pk,Pu,Pt] = homoInvRobCamPhoto(R,C,k,u,t)

% HOMOINVROBCAMPHOTO Inverse projection from camera in robot, in homog. coordinates.
%   HOMOINVROBCAMPHOTO(R,C,K,U,T) retroprojects the homogeneous pixel U from a
%   camera K in frame C, mounted on a robot R, using the homogeneous part T. 
%   K is a vector of intrinsic parameters K = [u0 v0 au av]'; 
%   R and C are frames {R,C} = [x y z a b c d]';

if nargout == 1
    
    pr = homoInvCamPhoto(C,k,u,t);
    p  = fromFrameHomo(R,pr);
    
else % Jac -- OK
    
    [pr,PRc,PRk,PRu,PRt] = homoInvCamPhoto(C,k,u,t);
    [p,Pr,Ppr]           = fromFrameHomo(R,pr);
    
    Pc = Ppr*PRc;
    Pk = Ppr*PRk;
    Pu = Ppr*PRu;
    Pt = Ppr*PRt;
    
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
u=[u1 u2 u3]';

[p,Pr,Pc,Pk,Pu,Pt] = homoInvRobCamPhoto(R,C,k,u,t);

simplify(Pr-jacobian(p,R))
simplify(Pc-jacobian(p,C))
simplify(Pk-jacobian(p,k))
simplify(Pu-jacobian(p,u))
simplify(Pt-jacobian(p,t))
