function [am,Aa,Aq,Ab] = acc(ai,q,ba,g)

% ACC Accelerometer readings
%   ACC(A,Q,B,G) gives the readings of an accelerometer with orientation Q
%   when it is subject to an acceleration A. B is the sensor bias and G the
%   local gravity vector.
%
%   [AM,Aa,Aq,Ab] = ACC(...) returns the readings AM and the Jacobians Aa,
%   Aq and Ab with respect to A, Q and B.
%
%   The measurement function is:
%
%       Am = R(Q)'*(A - G) + B + na
%
%   where na is additive white noise
%
%   Earth rotation is neglected.
%
%   See also INVACC, GYRO

Rt = q2R(q)';

am = Rt*(ai-g) + ba;

if nargout > 1 % Jacobians

    Aa = Rt;

    ag = ai-g;
    x = ag(1);
    y = ag(2);
    z = ag(3);
    a = q(1);
    b = q(2);
    c = q(3);
    d = q(4);


    Aq=[[  2*a*x+2*d*y-2*c*z,  2*b*x+2*c*y+2*d*z, -2*c*x+2*b*y-2*a*z, -2*d*x+2*a*y+2*b*z]
        [ -2*d*x+2*a*y+2*b*z,  2*c*x-2*b*y+2*a*z,  2*b*x+2*c*y+2*d*z, -2*a*x-2*d*y+2*c*z]
        [  2*c*x-2*b*y+2*a*z,  2*d*x-2*a*y-2*b*z,  2*a*x+2*d*y-2*c*z,  2*b*x+2*c*y+2*d*z]];


    Ab = eye(3);

end
