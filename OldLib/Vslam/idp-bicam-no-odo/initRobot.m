% INITROBOT  Initialize robot
%   This is a script - it takes no arguments
%   It initializes a robot in the following way:
%     Rob is the estimated robot
%       r: range in the map state vector
%
%   See also INITCAM

global PDIM VDIM SDIM

Rob(2) = emptyRobot;

% Initial positions
xi(:,1) = [0    0   1]';
xi(:,2) = [0  -.75  1]';

% Initial orientations
qi(:,1) = e2q(deg2rad([0 5 0]'));
qi(:,2) = e2q(deg2rad([0 5 0]'));

% Estimated robot
for i = 1:2
    Rob(i).id   = i;
    
    Rob(i).X    = [xi(:,i);qi(:,i)];
    Rob(i)      = updateFrame(Rob(i));

    Rob(i).V    = zeros(VDIM,1); % velocities
    Rob(i).V(1) = 0;

    Rob(i).r    = (i-1)*SDIM+(1:PDIM); % range for robot pose in map
    Rob(i).vr   = (i-1)*SDIM+PDIM+(1:VDIM); % range for robot states in map
    Rob(i).sr   = (i-1)*SDIM+(1:SDIM); % range for robot state

    % Trajectory log
    Rob(i).traj = zeros(3,Nframes);

end

