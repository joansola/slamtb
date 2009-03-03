function [p,Pr,Pc,Ppx,Ps] = invRobCamPhoto(R,cam,pix,s)

% INVROBCAMPHOTO Retroproject a photo from a robot with a camera
%   P = INVROBCAMPHOTO(R,C,PIX,S) retroprojects a pixel taken
%   from a camera CAM mounted in a robot at frame R to obtain
%   a point in space P at range S. CAM is a structure with
%   camera frame CAM.C and calibration parameters CAM.cal.
%
%   Frames R and C must be specified in two vectors containing:
%     translation vector t
%     orientation quaternion q


if nargout < 2
    p = fromFrame(R,invCamPhoto(cam,pix,s));
else
    [pr,PRc,PRpx,PRs] = invCamPhoto(cam,pix,s);
    [p,Pr,Ppr] = fromFrame(R,pr);

    Pc  = Ppr*PRc;
    Ppx = Ppr*PRpx;
    Ps  = Ppr*PRs;
end