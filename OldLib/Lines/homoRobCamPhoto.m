function [u,s,Ur,Uc,Uk,Up] = homoRobCamPhoto(R,C,k,p)

% HOMOROBCAMPHOTO Projection to camera in robot, in homog. coordinates.
%   HOMOROBCAMPHOTO(R,C,K,U,T) projects the homogeneous pixel U to a
%   camera K in frame C, mounted on a robot R. 
%   K is a vector of intrinsic parameters K = [u0 v0 au av]'; 
%   R and C are frames {R,C} = [x y z a b c d]';
%
%   [U,S] = ... returns also the point's depth S wrt the camera plane
%
%   [u,s,Ur,Uc,Uk,Up] = ... returns the Jacobians wrt R, C, K, and P

if nargout == 1
    
    pr    = toFrameHomo(R,p);
    [u,s] = homoCamPhoto(C,k,pr);
    
else % Jac -- OK
    
    [pr,PRr,PRp]    = toFrameHomo(R,p);
    [u,s,Uc,Uk,Upr] = homoCamPhoto(C,k,pr);
    
    Ur = Upr*PRr;
    Up = Upr*PRp;
    
end

return

%%
syms xr yr zr ar br cr dr real
syms xc yc zc ac bc cc dc real
syms p1 p2 p3 p4 real
syms u0 v0 au av real

R=[xr yr zr ar br cr dr]';
C=[xc yc zc ac bc cc dc]';
k=[u0 v0 au av]';
p=[p1 p2 p3 p4]';

[u,s,Ur,Uc,Uk,Up] = homoRobCamPhoto(R,C,k,p);

simplify(Ur-jacobian(u,R))
simplify(Uc-jacobian(u,C))
simplify(Uk-jacobian(u,k))
simplify(Up-jacobian(u,p))
