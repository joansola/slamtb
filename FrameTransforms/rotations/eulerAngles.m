% EULERANGLES  Help on Euler angles for the rotations/ toolbox.
%
%   We specify the Euler angles as a column 3-vector
%
%       e = [roll pitch yaw]',
%
%   where 
%       roll   is a positive rotation around the X-axis, 
%       pitch  is a positive rotation around the Y-axis, and 
%       yaw    is a positive rotation around the Z-axis. 
%   
%   The orientation of a 3D solid with respect to the cartesian axes XYZ is
%   given by the following ordered sequence of three elementary rotations:
%
%       1. rotation around the Z-axis - the yaw angle;
%       2. rotation around the rotated Y-axis - the pitch angle;
%       3. rotation around the doubly rotated X-axis - the roll angle.
%
%   The three Euler angles are limited by gimbal lock. It is up to the user
%   to ensure that the following conditions are met before calling any
%   function with Euler angles:
%
%       -pi   <= roll  < pi
%       -pi/2 <= pitch < pi/2
%       -pi   <= yaw   < pi , or 0 <= yaw < 2pi
%
%   Interesting functions involving Euler angles are:
%
%       e2q, q2e        conversion to and from quaternion.
%       e2R, R2e        conversion to and from rotation matrix.
%       epose2qpose     Euler-based frame to quaternion-based frame.
%       qpose2epose     the inverse of the above.
%
%   See also E2Q, Q2E, E2R, R2E, EPOSE2QPOSE, QPOSE2EPOSE, QUATERNION.

%   (c) 2009 Joan Sola @ LAAS-CNRS.
