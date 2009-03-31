function [Xo, Xo_x, Xo_u] = constVel(X, u, dt)

% CONSTVEL  Constant velocity motion model.
%   X = CONSTVEL(X, U, DT) performs one time step to the constant velocity
%   model:
%       x = x + v*dt
%       q = q . v2q(w*dt)
%       v = v + uv
%       w = w + uw
%
%   where 
%       X = [x;q;v;w] is the state consisting of position, orientation
%           quaternion, linear velocity and angular velocity,
%       U = [uv;uw] are linear and angular velocity perturbations or
%           controls,
%       DT is the sampling time.
%
%   X = CONSTVEL(X, DT) assumes U = zeros(6,1).
%
%   [X, X_x, X_u] = CONSTVEL(...) returns the Jacobians wrt X and U.
%
%   See also RPREDICT, QPREDICT, V2Q, QUATERNION.

% (c) 2009 Joan Sola @ LAAS-CNRS.


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
    q = qpredict(q,w,dt,'exact');
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