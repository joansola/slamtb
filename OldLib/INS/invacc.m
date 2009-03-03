function [ai,Am,Aq,Ab,Ag] = invacc(am,q,ba,gE)

% INVACC  Get acceleration from accelerometer readings
%   A = INVACC(AM,Q,B,G) gets acceleration A from accelerometer readings AM
%   given sensor orientation quaternion Q, sensor biases B and local
%   gravity vector G.
%
%   [A,Am,Aq,Ab] = (...) returns Jacobians wrt measurements, quaternion Q
%   and bias B
%
%   This is the inverse of the measurement function ACC:
%
%       Am = R(Q)*(A - G) + B + na
%
%   where na is additive white noise
%
%   Earth rotation is neglected.
%
%   See also ACC, SPREDICT, VPREDICT, QPREDICT, INVGYRO

% OK jacobians 10/01/2007 @ Joan Sola

R = q2R(q);
amba = am - ba;

ai = R*amba + gE;

if nargout > 1
    Am = R;

    if nargout > 2
        x = amba(1);
        y = amba(2);
        z = amba(3);
        a = q(1);
        b = q(2);
        c = q(3);
        d = q(4);

        Aq=[[  2*a*x-2*d*y+2*c*z,  2*b*x+2*c*y+2*d*z, -2*c*x+2*b*y+2*a*z, -2*d*x-2*a*y+2*b*z]
            [  2*d*x+2*a*y-2*b*z,  2*c*x-2*b*y-2*a*z,  2*b*x+2*c*y+2*d*z,  2*a*x-2*d*y+2*c*z]
            [ -2*c*x+2*b*y+2*a*z,  2*d*x+2*a*y-2*b*z, -2*a*x+2*d*y-2*c*z,  2*b*x+2*c*y+2*d*z]];
        if nargout > 3
            Ab = -R;

            if nargout > 4
                Ag = eye(3);
                
            end
        end
    end
end


