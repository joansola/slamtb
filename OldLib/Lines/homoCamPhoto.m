function [u,s,Uc,Uk,Up] = homoCamPhoto(C,k,p)

% HOMOCAMPHOTO Projection to camera, in homog. coordinates.
%   HOMOCAMPHOTO(C,K,U,T) projects the homogeneous pixel U to a camera K in
%   frame C. 
%   K is a vector of intrinsic parameters K = [u0 v0 au av]'; 
%   C is a frame C = [x y z a b c d]';
%
%   [U,S] = ... returns also the point's depth S wrt the camera plane

if nargout == 1
    
    pc    = toFrameHomo(C,pr);
    [u,s] = homoPinHole(k,pc);
    
else % Jac -- OK
    
    [pc,PCc,PCp] = toFrameHomo(C,p);
    [u,s,Uk,Upc] = homoPinHole(k,pc);
    
    Uc = Upc*PCc;
    Up = Upc*PCp;
    
end

return

%%
syms xc yc zc ac bc cc dc real
syms p1 p2 p3 p4 real
syms u0 v0 au av real

C=[xc yc zc ac bc cc dc]';
k=[u0 v0 au av]';
p=[p1 p2 p3 p4]';

[u,s,Uc,Uk,Up] = homoCamPhoto(C,k,p);

simplify(Uc-jacobian(u,C))
simplify(Uk-jacobian(u,k))
simplify(Up-jacobian(u,p))
