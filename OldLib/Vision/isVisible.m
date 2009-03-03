function vis = isVisible(Cam,p)

% ISVISIBLE  visibility check
%   V = ISVISIBLE(CAM,P) is true if point P in camera frame
%   is visible by camera CAM (that is, if it is inside 
%   the camera's field of view)

hfov = Cam.nfv(1);
vfov = Cam.nfv(2);

if p(3) > .1 & abs(p(1)/p(3)) < hfov & abs(p(2)/p(3)) < vfov
    vis = 1;
else 
    vis = 0;
end