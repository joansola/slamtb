function Rob = robotInertial(Rob,Pert,dt)

% ROBOTINERTIAL  Robot inertial evolution
%   ROB = ROBOTINERTIAL(ROB,PERT,DT) performs one time step to robot state
%   ROB. This state is divided into two sections, pose and velocities:
%       ROB.X = [x;q] is the pose with position x and orientation q.
%       ROB.V = [v;w] are the linear and angular velocities v and w.
%
%   The time evolution assumes v and w are constant and modifies x and q
%   the amounts corresponding to a time step DT. 
%   The global map Map is also updated in mean Map.X and covariance Map.P
%   where the perturbations over v and w are specified with the covariances
%   matrix PERT.Q.

global Map

% ranges
sr = Rob.sr; % pose and velocities

% split
% x = Rob.X(1:3); % position
% q = Rob.X(4:7); % orientation
% v = Rob.V(1:3); % velocity
% w = Rob.V(4:6); % angular rates
% 
% % time step and Jacobians
% [x,Xx,Xv] = rpredict(x,v,dt);
% [q,Qq,Qw] = qpredict(q,w,dt);
% [Vv,Ww]   = deal(eye(3));
% 
% % some constants
% Z34 = zeros(3,4);
% Z43 = zeros(4,3);
% Z33 = zeros(3);
% 
% % Full Jacobians
% Fr  = [...
%     Xx  Z34 Xv  Z33 
%     Z43 Qq  Z43 Qw  
%     Z33 Z34 Vv  Z33 
%     Z33 Z34 Z33 Ww ];
% % Fu  = [zeros(7,6);eye(6)*sqrt(dt)];
% Fu  = [zeros(7,6);eye(6)];

% Inertial
X = [Rob.X;Rob.V];
[X, Fr, Fu] = inertial(X, dt);
Rob.X = X(1:7);
Rob.V = X(8:13);

% Update robot state
Rob = updateFrame(Rob);

% update map state
Map.X(sr) = X;

% update map covariance
blockPredict(sr,Fr,Fu,Pert.Q);
