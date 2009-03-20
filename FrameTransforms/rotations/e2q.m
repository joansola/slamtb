function [q,Qe] = e2q(e)

% E2Q Euler angles to quaternion conversion.
%   Q = vE2Q(E) gives the quaternion Q corresponding to the Euler angles
%   vector E = [roll;pitch;yaw].
%
%   [Q,J] = E2Q(E) returns also the Jacobian matrix J = dQ/dE.
%
%   See also QUATERNION, R2Q, Q2E, Q2V.

%   (c) 2009 Joan Sola @ LAAS-CNRS.


qx = au2q(e(1),[1;0;0]); %  roll rot. on X axis
qy = au2q(e(2),[0;1;0]); % pitch rot. on Y axis
qz = au2q(e(3),[0;0;1]); %   yaw rot. on Z axis

q = qProd(qProd(qz,qy),qx);

if nargout == 2

    sr = sin(e(1)/2);
    sp = sin(e(2)/2);
    sy = sin(e(3)/2);

    cr = cos(e(1)/2);
    cp = cos(e(2)/2);
    cy = cos(e(3)/2);

    Qe = 0.5*[
        [ -cy*cp*sr+sy*sp*cr, -cy*sp*cr+sy*cp*sr, -sy*cp*cr+cy*sp*sr]
        [  cy*cp*cr+sy*sp*sr, -cy*sp*sr-sy*cp*cr, -sy*cp*sr-cy*sp*cr]
        [ -cy*sp*sr+sy*cp*cr,  cy*cp*cr-sy*sp*sr, -sy*sp*cr+cy*cp*sr]
        [ -sy*cp*sr-cy*sp*cr, -cy*cp*sr-sy*sp*cr,  cy*cp*cr+sy*sp*sr]
        ];
end

return

%%
syms r p y real
e = [r;p;y];

[q,Qe] = e2q(e);

simplify(Qe-jacobian(q,e))
