function [m,Mr,Mc,Mo] = invDirRobCamPhoto(Rob,Cam,Obs)

% INVDIRROBCAMPHOTO global direction angles from robot, camera and
% observation
%   INVDIRROBCAMPHOTO(ROB,CAM,OBS) returns a 2-vector with the direction
%   angles pitch and yaw of the ray observed at OBS by a camera CAM mounted
%   on a robot ROB.
%
%   [m,Mr,Mc,Mo] = (...) gives the Jacobians wrt each of the inputs.

% (c) 2008 Joan Sola

[u,Uc,Uo] = invCamPhoto(Cam,Obs.y,1); % local direction vector
[v,Vq,Vu] = Rp(Rob.q,u); % global direction vector
[m,Mv]    = vec2py(v);   % global direction angles

if nargout > 1 % we want Jacobians
    Vr = [zeros(3) Vq];

    Mr = Mv*Vr;
    Mc = Mv*Vu*Uc;
    Mo = Mv*Vu*Uo;
end

