function p3d = invBiCamPhoto(Cam1,Cam2,y1,y2)

% INVBICAMPHOTO Get 3D point from two camera observations.
%   P3D = INVBICAMPHOTO(CAM1,CAM2,OBS1,OBS2) gives the position
%   of a 3D point from two observations OBS1 and OBS taken from
%   two cameras CAM1 and CAM2. The result is expressed in the
%   CAM1 frame.


global WDIM

% get 3d point - robot frame
o1 = Cam1.X(1:WDIM);
o2 = Cam2.X(1:WDIM);
v1 = invCamPhoto(Cam1,y1,1) - o1;
v2 = invCamPhoto(Cam2,y2,1) - o2;
[pc,p1,p2] = inter3D(o1,v1,o2,v2);

% go to camera frame
p3d = toFrame(Cam1,p1);

