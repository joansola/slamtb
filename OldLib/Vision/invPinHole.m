function [p,Ppx,Ps,Pc,Pundist] = invPinHole(pix,s,c)

% INVPINHOLE Inverse Pin Hole Camera function
%   P = INVPINHOLE(PIX,S) returns the position of a 3D point
%   at a range S that is projected in a camera at pixel PIX.
%   Default calibration parameters are:
%     u0 = 0
%     v0 = 0
%     au = 1
%     av = 1
%
%   P = INVPINHOLE(PIX,S,CAL) allows the introduction of the camera's
%   calibration parameters:
%     CAL = [u0 v0 au av]'
%
%   P = INVPINHOLE(PIX,S,CAM) allows for specification of
%   the calibration prameters CAM.cal of the camera:
%     CAM.cal = [u0 v0 au av]'
%
%   If PIX is a pixel matrix, INVPINHOLE(PIX,...) returns a
%   points matrix P, with these matrices defined as
%     P   = [p1 ... pn];       pi = [xi;yi;zi]
%     PIX = [pix1 ... pixn]; pixi = [ui;vi]
%
%   P = INVPINHOLE(...,CAM) accepts the inverse distortion
%   parametres CAM.undist to retroproject distorted point images.
%   See UNDISTORT for information about undistortion.
%
%   [p,Ppx,Ps,Pc,Pundist] = INVPINHOLE(...) gives the jacobians wrt PIX, S,
%   CAM.cal and CAM.undistort.
%
%   See also PINHOLE, PINHOLEJAC, INVPINHOLEJAC, RETRO,
%   DEPIXELLISE, UNDISTORT

if isstruct(c)
    cam = c; % camera structure provided
else
    cam.cal = c; % only intrinsic parameters proveded
end

switch nargin
    case 2 % only retro-projection
        if nargout < 2
            p = retro(pix,s);
        else % jacobians
            [p,Ppx,Ps] = retro(pix,s);
        end

    case 3 % above with depixellisation
        if ~isfield(cam,'undist')
            if nargout < 2
                p = retro(depixellise(pix,cam.cal),s);
            else
                [u,Upx,Uc] = depixellise(pix,cam.cal);
                [p,Pu,Ps] = retro(u,s);
                Ppx = Pu*Upx;
                Pc  = Pu*Uc;
            end
        else % all above with distortion correction
            if nargout < 2
                p = retro(undistort(depixellise(pix,cam.cal),cam.undist),s);
            else
                [ud,UDpx,UDc] = depixellise(pix,cam.cal);
                [u,Uud,Uundist] = undistort(ud,cam.undist);
                [p,Pu,Ps] = retro(u,s);
                Ppx = Pu*Uud*UDpx;
                Pc  = Pu*Uud*UDc;
                Pundist = Pu*Uundist;
            end
        end

end


