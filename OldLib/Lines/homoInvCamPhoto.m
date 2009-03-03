function [p,Pc,Pk,Pu,Pt] = homoInvCamPhoto(C,k,u,t)

% HOMOINVCAMPHOTO Inverse projection from camera in homog. coordinates.
%   HOMOINVCAMPHOTO(C,K,U,T) retroprojects the homogeneous pixel U from a
%   camera K in frame C, using the homogeneous part T. 
%   K is a vector of intrinsic parameters K = [u0 v0 au av]'; 
%   C is a frame C = [x y z a b c d]';

if nargout == 1
    
    pc = homoInvPinHole(k,u,t);
    p = fromFrameHomo(C,pc);
    
else % Jac -- OK tested through HOMOINVROBCAMPHOTO
    
    [pc,PCk,PCu,PCt] = homoInvPinHole(k,u,t);
    [p,Pc,Ppc] = fromFrameHomo(C,pc);
    
    Pk = Ppc*PCk;
    Pu = Ppc*PCu;
    Pt = Ppc*PCt;
    
end

return

%%
