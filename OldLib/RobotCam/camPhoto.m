function [pix,depth,front] = camPhoto(cam,p)

% CAMPHOTO Take photo from a camera
%   PIX = CAMPHOTO(CAM,P) takes a photo of point P with
%   a camera CAM. CAM is a structure with camera frame CAM.X
%   and calibration parameters CAM.cal and eventually distortion
%   parameters CAM.dist.
%   Frame X must be specified in a vector containing:
%     translation vector t
%     orientation quaternion q
%   (See TOFRAME for information about reference frames)
%
%   If P is a points matrix, CAMPHOTO(...,P) returns a pixel
%   matrix PIX, with these matrices defined as
%     P   = [p1 ... pn];       pi = [xi;yi;zi]
%     PIX = [pix1 ... pixn]; pixi = [ui;vi]
%
%   [PIX,DEPTH] = CAMPHOTO(...) returns the vector DEPTH of
%   points depths from the camera center.
%
%   [PIX,DEPTH,FRONT] = CAMPHOTO(...) returns the vector FRONT
%   with ones in those points with positive depth.
%
%   See also PINHOLE, INVCAMPHOTO


[pix,depth,front] = pinHole(toFrame(cam,p),cam);
