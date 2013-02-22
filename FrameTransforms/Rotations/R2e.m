function e = R2e(R)

% R2E  Rotation matrix to Euler angles conversion.
%   R2E(R) returns the euler angles vector [roll;pitch;yaw] corresponding
%   to the orientation of hte rotation matrix R. The result is such that
%   E2R(R2E(R)) = R and R2E(E2R(E)) = E.
%
%   See also E2R, FRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



s = whos('R');

if (strcmp(s.class,'sym'))
    roll  = atan(R(3,2)/R(3,3));
    pitch = asin(-R(3,1));
    yaw   = atan(R(2,1)/R(1,1));
else
    roll  = atan2(R(3,2),R(3,3));
    pitch = asin(-R(3,1));
    yaw   = atan2(R(2,1),R(1,1));
end

e = [roll;pitch;yaw];









