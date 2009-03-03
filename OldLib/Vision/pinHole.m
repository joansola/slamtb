function [pix,depth,front] = pinHole(p,c)

% PINHOLE Pin-hole camera model
%   PIX = PINHOLE(P) gives the projected pixel PIX of a point P
%   in a pin-hole camera with calibration parameters
%     u0 = 0
%     v0 = 0
%     au = 1
%     av = 1
%   given reference frames RDF,RD (right-down-front for the
%   3D world points and right-down for the pixel)
%
%   PIX = PINHOLE(P,CAL) allows the introduction of the camera's
%   calibration parameters:
%     CAL = [u0 v0 au av]'
%
%   PIX = PINHOLE(P,CAM) allows the introduction of the camera's
%   calibration parameters via the structure CAM:
%     CAM.cal = [u0 v0 au av]'
%
%   If P is a points matrix, PINHOLE(P,...) returns a pixel
%   matrix PIX, with these matrices defined as
%     P   = [p1 ... pn];       pi = [xi;yi;zi]
%     PIX = [pix1 ... pixn]; pixi = [ui;vi]
%
%   PIX = PINHOLE(P,CAM) also accepts a radial distortion
%   parameters vector in the form:
%     CAM.dist = [K2 K4 K6 ...]
%   so that the new pixel is distorted following the distortion
%   equation:
%     U_D = U * (1 + K2*R^2 + K4*R^4 + ...)
%   with R^2 = sum(U.^2), being U the projected point in the
%   image plane for a camera with unit focal length.
%
%   [PIX,DEPTH] = PINHOLE(...) returns the vector DEPTH of
%   depths from the camera center.
%
%   [PIX,DEPTH,FRONT] = PINHOLE(...) returns the vector FRONT
%   with ones in those points with positive depth.
%
%   See also CAL2INT, PIX2DIR, PROJECT, DISTORT, PIXELLISE

if isstruct(c)
    cam = c; % camera structure provided
else
    cam.cal = c; % only intrinsic parameters proveded
end

switch nargin
    case 1
        pix = project(p);
    case 2
        if ~isfield(cam,'dist')
            pix = pixellise(project(p),cam.cal);
        else
            rmax2 = (cam.cal(1)/cam.cal(3))^2 + (cam.cal(2)/cam.cal(4))^2;
            rmax  = sqrt(rmax2); % maximum radius in normalized coordinates

            pix = pixellise(distort(project(p),cam.dist,rmax),cam.cal);
%             pix = pixellise(distort(project(p),cam.dist),cam.cal);
        end
end

switch nargout
    case 2
        depth = p(3,:);
    case 3
        depth = p(3,:);
        w  = whos('depth');

        if ~strcmp(w.class,'sym')
            front = depth > 0;
        else
            front = depth; % posa aquest per a calcul simbolic
        end
end

return

%%

