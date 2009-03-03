function [px,PXr,PXc,PXi] = idpRobCamPhoto(Rob,Cam,idp,depth)

% IDPROBCAMPHOTO  Takes a photo if an IDP point from a camera on a robot.
%   IDPROBCAMPHOTO(ROB,CAM,IDP) returns the pixel resulting from projecting
%   the point coded by IDP (Inverse depth) into a camera CAM mounted on a
%   robot ROB.
%
%   PIX = IDPROBCAMPHOTO(ROB,CAM,IDP,DEPTH) with DEPTH~=0 adds the depth of the point
%   in camera frame as the third component of the output vector PIX.
%
%   [pix,PXr,PXc,PXi] = IDPROBCAMPHOTO(...) returns the jacobians wrt
%   ROB.X, CAM.X and IDP.
%
%   See also IDP2P to obtain information on the inverse depth
%   representation of IDP.

[p,Pi] = idp2p(idp);

[px,d] = robCamPhoto(Rob,Cam,p);

if nargout > 1
    [PXr,PXc,PXp] = robCamPhotoJac(Rob,Cam,p);
    PXi = PXp*Pi;
end

if depth
    px(3,:) = d;
end

return

%% test jacobians (too slow!!!)

syms x y z a b c d xc yc zc ac bc cc dc xi yi zi pt yw ro real
rob.X = [x;y;z;a;b;c;d];
rob = updateFrame(rob);
cam = Cam(1);
cam.X = [xc;yc;zc;ac;bc;cc;dc];
cam = updateFrame(cam);
idp   = [xi;yi;zi;pt;yw;ro];

[px,PXr,PXc,PXi] = idpRobCamPhoto(rob,cam,idp);

% simple(PXr - jacobian(px,rob.X))
% simple(PXc - jacobian(px,cam.X))
% simple(PXi - jacobian(px,idp))
