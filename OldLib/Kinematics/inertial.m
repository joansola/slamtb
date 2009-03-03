function [Xo, Xo_x, Xo_u] = inertial(X, u, dt)

% INERTIAL inertial constant velocity motion model, 3D.
%   INERTIAL(X, dt) predicts the state X one time step dt in the future,
%   according to a constant velocity model. The state consists of position x,
%   quaternion q, linear speed v and angular speed w:
%
%       X = [x ; q ; v ; w] , 13-vector
%
%   where the angular speed w is expressed in body frame.
%
%   INERTIAL(X, U, dt) accepts velocity changes U (6-vector) to affect
%   linear velocities as follows:
%
%       v = v + U(1:3)
%       w = w + U(4:6)
%
%   [Xo, Xo_x, Xo_u] = INERTIAL(...) returns the Jacobians wrt X and U.
%

if nargin == 2
    dt = u;
    u = zeros(6,1);
end

% split inputs
x = X(1:3);   % position
q = X(4:7);   % orientation
v = X(8:10);  % linear velocity
w = X(11:13); % angular velocity

uv = u(1:3);  % linear vel. change (control)
uw = u(4:6);  % angular vel. change (control)

if nargout == 1

    % time step
    x = rpredict(x,v,dt);
    q = qpredict(q,w,dt);
    v = v + uv;
    w = w + uw;
    
    % new pose
    Xo = [x;q;v;w];

else % Jacobians

    % time step and Jacobians
    [x,Xx,Xv] = rpredict(x,v,dt);
    [q,Qq,Qw] = qpredict(q,w,dt);
    v = v + uv;
    w = w + uw;
    [Vv,Ww,Vuv,Wuw]   = deal(eye(3));
        
    % some constants
    Z34 = zeros(3,4);
    Z43 = zeros(4,3);
    Z33 = zeros(3);

    % new pose
    Xo = [x;q;v;w];

    % Full Jacobians
    Xo_x  = [...
        Xx  Z34 Xv  Z33
        Z43 Qq  Z43 Qw
        Z33 Z34 Vv  Z33
        Z33 Z34 Z33 Ww ]; % wrt state

    Xo_u  = [...
        zeros(7,6)
        Vuv Z33
        Z33 Wuw];  % wrt control

end