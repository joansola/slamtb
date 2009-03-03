function R=euler2mat(euler)

% EULER2MAT Euler angles to rotation matrix
%   EULER2MAT(EU) gives the rotation matrix body to world
%   corresponding to the body orientation given
%   by the euler angles vector EU (roll, pitch, yaw)
%
%   See also R2E

r=euler(1); %roll
p=euler(2); %pitch
y=euler(3); %yaw

sr = sin(r);
cr = cos(r);
sp = sin(p);
cp = cos(p);
sy = sin(y);
cy = cos(y);

R= [cp*cy -cr*sy+sr*sp*cy  sr*sy+cr*sp*cy
    cp*sy  cr*cy+sr*sp*sy -sr*cy+cr*sp*sy
    -sp          sr*cp           cr*cp   ];
