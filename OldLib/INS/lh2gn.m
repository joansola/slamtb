function g = lh2gn(lat,h)

% LH2GN Latitude and height to gravity value conversion 
%   G = LH2G(L,H) returns the value of the gravity acceleration in meters
%   per squared seconds at a position on earth at latitude L [rad] and
%   height above sea level H [m]. It uses the WGS84 ellipsoid.

[a,b,e2]=refell('wgs84');
[x,y,z] = ell2xyz(lat,0,h,a,e2);
[gx,gy,gz]=xyz2grav(x,y,z);
g = norm([gx gy gz]);
