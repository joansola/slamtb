function R = v2R(v)
% V2R Rotation vector to rotation matrix conversion
%   V2R(V) computes the rotation matrix corresponding to the
%   rotation vector V. Uses rodrigues formula

[a,u] = v2au(v);

Om = [  0   -u(3)  u(2)
       u(3)   0   -u(1)
      -u(2)  u(1)   0  ];
  
R = eye(3) + sin(a)*Om + (1-cos(a))*Om^2;

