% ROBCAMTEST Numerically Tests functions in ROBCAM directory 
%
%   See also CAMPHOTO, INVCAMPHOTO, 
%            ROBCAMPHOTO, INVROBCAMPHOTO

% robot frame
t = [1 2 3]';
q = [1 2 3 4]';
q = q/norm(q);
R = [t;q];

% camera frame
t = [3 2 1]';
q = [4 3 2 1]';
q = q/norm(q);
C = [t;q];

% camera parameters
cal = [100 100 200 200]';

% Camera structure
cam.C = C;
cam.cal = cal;

% 3D point
p = [10,20,30]'

% range
s = 13.2;

% pixel projection
pix = robCamPhoto(R,cam,p)

% retroprojection
p = invRobCamPhoto(R,cam,pix,s)

% new pixel projection
pix = robCamPhoto(R,cam,p)


