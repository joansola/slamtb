function g = llh2g(lat,long,h)

% LH2G Latitude, longitude and height to ECEF gravity vector conversion 
%   G = LH2G(LA,LO,H) returns the gravity acceleration vector in meters per
%   squared seconds at a position on earth at latitude LA, longitude LO and
%   height above sea level H. The result is in ECEF coordinates. Uses WGS84
%   ellipsoid.

[a,b,e2]   = refell('wgs84');
[x,y,z]    = ell2xyz(lat,long,h,a,e2);
[gx,gy,gz] = xyz2grav(x,y,z);
g          = [gx;gy;gz];