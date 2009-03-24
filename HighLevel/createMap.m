function Map = createMap(Rob,Sen,Lmk)

% CREATEMAP Create an empty Map structure.
%   Map = CREATEMAP(Rob,Sen,Lmk) creates the structure Map from the
%   information contained in Rob, Sen and Lmk. The resulting structure is
%   an EKF map with all empty spaces, able to host all states necessary for
%   Rob, Sen and Lmk. It contains the fields:
%       .used   flags vector to used states in the map
%       .x      state vector
%       .P      covariances matrix
%       .size   size of the map

%   (c) 2009 Joan Sola @ LAAS-CNRS.


R = [Rob.state];
S = [Sen.state];
L = [Lmk.state];

n = sum([R.size S.size L.size]);

Map.used = false(n,1);

Map.x = zeros(n,1);
Map.P = zeros(n,n);

Map.size = n;

