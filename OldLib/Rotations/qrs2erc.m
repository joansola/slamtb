function [e_rc,ERCqrs] = qrs2erc(q_rs)

% QRS2ERC  Robot-to-sensor quaternion to Robot-to-camera Euler a. conversion
%   QRS2ERC(QRS) gives the euler angles of the orientation of the camera in
%   a robot, given the orientation of the optical sensor or lenses. It is
%   supposed that a rigid rotation exists between camera and sensor frames.
%   This rotation is given by
%
%                         |  0   0   1 |
%       RCS = flu2rdf() = | -1   0   0 |
%                         |  0  -1   0 |
%
%   indicating that the camera frame is of the FLU type and the sensor
%   frame of the RDF type.
%
%   [Erc,ERCqrs] = QRS2ERC(...) provides the Jacobian wrt QRS


q_sc = R2q(flu2rdf'); % sensor to camera quaternion

q_rc = qProd(q_rs,q_sc); % robot to camera quaternion

e_rc = q2e(q_rc); % robot to camera Euler angles

if nargout > 1 % Jacobian is requested

    [a,b,c,d] = deal(q_rs(1),q_rs(2),q_rs(3),q_rs(4));

    ERCqrs = [
        [                                                                               -d/(a^2+d^2),                                                                                c/(c^2+b^2),                                                                               -b/(c^2+b^2),                                                                                a/(a^2+d^2)]
        [ -2*a/(1-a^4+2*a^2*b^2+2*a^2*c^2-2*a^2*d^2-b^4-2*b^2*c^2+2*b^2*d^2-c^4+2*c^2*d^2-d^4)^(1/2),  2*b/(1-a^4+2*a^2*b^2+2*a^2*c^2-2*a^2*d^2-b^4-2*b^2*c^2+2*b^2*d^2-c^4+2*c^2*d^2-d^4)^(1/2),  2*c/(1-a^4+2*a^2*b^2+2*a^2*c^2-2*a^2*d^2-b^4-2*b^2*c^2+2*b^2*d^2-c^4+2*c^2*d^2-d^4)^(1/2), -2*d/(1-a^4+2*a^2*b^2+2*a^2*c^2-2*a^2*d^2-b^4-2*b^2*c^2+2*b^2*d^2-c^4+2*c^2*d^2-d^4)^(1/2)]
        [                                                                               -d/(a^2+d^2),                                                                               -c/(c^2+b^2),                                                                                b/(c^2+b^2),                                                                                a/(a^2+d^2)]
        ];

end
return

%% Construct the Jacobian
syms a b c d real

q_rs = [a b c d]'

q_cs = R2q(flu2rdf())
q_sc = R2q(flu2rdf')

q_rc = qProd(q_rs,q_sc)

e_rc = q2e(q_rc)

jac1 = simple(jacobian(e_rc,q_rs))

% test results
jac2 = q2erdfJac(q_rs)

Ejac = simplify(jac1 - jac2)