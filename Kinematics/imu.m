function y = imu(o, a, w, g, ab, wb)

% IMU Inertial Measurement Unit sensor model.
%   IMU(ORI, A, W) returns a 6-vector of 3-acc and 3-gyro measurements
%   corresponding to a moving body in a gravity field. The body has
%   orientation given by ORI (a rotation matrix, a quaternion or a Euler
%   angles triplet), with acceleration A and angular rate W. Acceleration
%   is measured in the inertial frame where the gravity field is defined.
%   the gravity field is g = [0;0;-9.8].
%
%   IMU(... , G) allows entering a different gravity field.
%
%   IMU(... , G, AB, WB) allows entering acc and gyro biases.

switch nargin
    case 3
        g  = [0;0;-9.8];
        ab = [0;0;0];
        wb = [0;0;0];
    case 4
        ab = [0;0;0];
        wb = [0;0;0];
    case 6
    otherwise
        error('??? Wrong number of arguments.')
end

switch numel(o)
    case 3
        R = e2R(o);
    case 4
        R = q2R(normvec(o));
    case 9
        if (size(o,1) ~= 3) || (norm(det(o)-1) > 1e-8)
            error('Wrongly specified rotation matrix')
        end
    otherwise
        error('Wrong orientation specification')
end

am = R'*(a - g) + ab;
wm = w + wb;

y = [am ; wm];
