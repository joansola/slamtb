function [u2,U2c1,U2c2,U2u1,U2s] = transCamPhoto(Cam1,Cam2,u1,s)

% TRANSCAMPHOTO  Projection of vanishing point
%   U2 = TRANSCAMPHOTO(CAM1,CAM2,U1) is the projection into CAM2 of the
%   vanishing point correcponding to the pixel UL observed in CAM1.
%
%   U2 = TRANSCAMPHOTO(CAM1,CAM2,U1,S) is the projection into CAM2 of the 
%   point at depth S correcponding to the pixel UL observed in CAM1.
%
%   [U2,U2c1,U2c2,U2u1,U2s] = TRANSCAMPHOTO(...) returns the Jacobians wrt
%   CAM1, CAM2, U1 and S 

if nargin < 4
    s = 1e100; % point at 'infinity'
end

[p,Pc1,Pu1,Ps] = invCamPhoto(Cam1,u1,s);
u2 = camPhoto(Cam2,p);
[U2c2,U2p] = camPhotoJac(Cam2,p);

U2u1 = U2p*Pu1;
U2c1 = U2p*Pc1;
U2s  = U2p*Ps;

