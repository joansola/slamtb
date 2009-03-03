function [R,Re] = e2R(e)

% E2R Euler angles to rotation matrix
%   E2R(EU) gives the rotation matrix body to world
%   corresponding to the body orientation given
%   by the euler angles vector EU (roll, pitch, yaw)
%
%   See also R2E

r  = e(1); %roll
p  = e(2); %pitch
y  = e(3); %yaw

sr = sin(r);
cr = cos(r);
sp = sin(p);
cp = cos(p);
sy = sin(y);
cy = cos(y);

R= [cp*cy -cr*sy+sr*sp*cy  sr*sy+cr*sp*cy
    cp*sy  cr*cy+sr*sp*sy -sr*cy+cr*sp*sy
    -sp          sr*cp           cr*cp   ];


if nargout > 1

    Re = [...
        [                                   0,                      -sin(p)*cos(y),                      -cos(p)*sin(y)]
        [                                   0,                      -sin(p)*sin(y),                       cos(p)*cos(y)]
        [                                   0,                             -cos(p),                                   0]
        [  sin(r)*sin(y)+cos(r)*sin(p)*cos(y),                sin(r)*cos(p)*cos(y), -cos(r)*cos(y)-sin(r)*sin(p)*sin(y)]
        [ -sin(r)*cos(y)+cos(r)*sin(p)*sin(y),                sin(r)*cos(p)*sin(y), -cos(r)*sin(y)+sin(r)*sin(p)*cos(y)]
        [                       cos(r)*cos(p),                      -sin(r)*sin(p),                                   0]
        [  cos(r)*sin(y)-sin(r)*sin(p)*cos(y),                cos(r)*cos(p)*cos(y),  sin(r)*cos(y)-cos(r)*sin(p)*sin(y)]
        [ -cos(r)*cos(y)-sin(r)*sin(p)*sin(y),                cos(r)*cos(p)*sin(y),  sin(r)*sin(y)+cos(r)*sin(p)*cos(y)]
        [                      -sin(r)*cos(p),                      -cos(r)*sin(p),                                   0]];

end

return

%%

syms r p y real

e = [r;p;y];

R = e2R(e);

Re = simplify(jacobian(R,e))