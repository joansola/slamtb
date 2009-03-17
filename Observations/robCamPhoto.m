function [pix,depth,front] = robCamPhoto(R,cam,p)

% ROBCAMPHOTO Take photo from a robot with a camera.
%   PIX = ROBCAMPHOTO(ROB,CAM,P) takes a photo of a point P with
%   a camera CAM mounted in a robot ROB. CAM is a
%   structure with camera frame CAM.X and calibration 
%   parameters CAM.cal and eventually distortion parameters
%   CAM.dist.
%   Frames CAM.X and ROB.X must be specified with vectors [t;q]
%   where:
%     t: translation vector 
%     q: orientation quaternion 
%   (See TOFRAME for information about reference frames)
%
%   If P is a points matrix, ROBCAMPHOTO(...,P) returns a pixel
%   matrix PIX, with these matrices defined as
%     P   = [p1 ... pn];       pi = [xi;yi;zi]
%     PIX = [pix1 ... pixn]; pixi = [ui;vi]
%
%   [PIX,DEPTH] = ROBCAMPHOTO(...) returns the vector DEPTH of
%   depths from camera center
%
%   [PIX,DEPTH,FRONT] = ROBCAMPHOTO(...) returns the vector FRONT
%   with ones in those points with positive depth.
%
%   See also PINHOLE, INVROBCAMPHOTO

% if nargout == 1
%     pix = camPhoto(cam,toFrame(R,p));
% else
%     [pix,front] = camPhoto(cam,toFrame(R,p));
% end

[pix,depth,front] = camPhoto(cam,toFrame(R,p));