function K = cal2int(cal)

% CAL2INT Calibration parameters to intrinsic matrix
%   CAL2INT(C) builds the intrinsic matrix of a pin-hole
%   camera whith calibraton parameters C=[u0 v0 au av]
%
%   Camera frame is FLU (x-front y-left z-up) with origin
%   at the focal point
%   Pixel is DR (u-down v-right) for RC(u-row v-column)
%   with origin at the upper left corner.


% camera calibration parameters
u0=cal(1);
v0=cal(2);
au=cal(3);
av=cal(4);

% Intrinsic matrix
K = [au 0 u0;0 av v0;0 0 1];