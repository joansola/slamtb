function Rob = robotMotion(Rob,Odo)

% ROBOTMOTION  Robot motion from odometry data
%   Rob = MOVE(Rob,Odo) performs ekf slam robot motion
%   for a robot Rob in a map Map evolving with odometry 
%   readings Odo.
%   Rob is a structure containing:
%     r: robot pose range in Map
%   Map is a structure containing:
%     X: state vector
%     P: covariances matrix
%   Odo is a structure containing:
%     u: mean of odometry vector
%     U: covariances matrix

global Map

if (nargin == 2) && (nargout == 1)
    
    % detailed input data
    u = Odo.u;
    U = Odo.U;
    r = Rob.r; % robot range in the state vector

    % odometry sub-vectors
    dx = u(1:3); % position increment
    de = u(4:6); % orientation increment
    
%     % Jacobians
%     [Fr,Fu] = odo3Jac(Rob,dx,de);
    
    % new robot pose
    [Rob,Fr,Fu] = odo3(Rob,dx,de);
%     Fu  = eye(DDIM);
    Rob = updateFrame(Rob);
    
    % update map state
    Map.X(r) = Rob.X;
    
    % update map covariance
    blockPredict(r,Fr,Fu,U);
    

else
    error('Bad number of arguments.')
end
