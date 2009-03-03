function [px,PXi,PXc] = idpCamPhoto(idp,Cam,depth)

% IDPCAMPHOTO  Takes a photo if an IDP point from a camera.
%   IDPCAMPHOTO(CAM,IDP) returns the pixel resulting from projecting the
%   point coded by IDP (Inverse depth) into a camera CAM.
%
%   PIX = IDPCAMPHOTO(IDP,CAM,DEPTH) with DEPTH~=0 adds the depth of the point
%   in camera frame as the third component of the output vector PIX.
%
%   [pix,PXc,PXi] = IDPCAMPHOTO(...) returns the jacobians wrt CAM.X and
%   IDP.
%
%   See also IDP2P to obtain information on the inverse depth
%   representation of IDP.

[p,Pi] = idp2p(idp);

[px,d] = camPhoto(Cam,p);

if nargout > 1
    [PXc,PXp] = camPhotoJac(Cam,p);
    PXi = PXp*Pi;
end

if depth
    px(3,:) = d;
end

return
