function visLm = visibleSet(world,Rob,Cam)

% VISIBLESET  Set of visible landmarks
%   VISIBLESET(WORLD,ROB,CAM) returns the set of points
%   in WORLD that are visible from the camera CAM mounted
%   on a robot at pose ROB.
%   WORLD is a 4-by-N matrix of N landmarks, where
%     the first component is the landmark identifier and 
%     the other three are the x-y-z components of the
%     landmarks
%   CAM is a structure containing
%     C: camera pose with respect to robot
%     nfv: normalized field of view [hor vert]'
%           (number of focal lengths)
%     dlim: observable depth bounds [dmin dmax]' (in m)
%   ROB is a structure containing
%     R: robot pose wrt world

% world sub-vectors
ids = world(1,:);  % identifiers
Ww  = world(2:4,:);% positions

% robot frame
% Rb = Rob.X;
% tr = Rb(1:3);
% qr = Rb(4:7);
% Rrt = ori2mat(qr)';
[tr,Rr] = getTR(Rob);
Rrt = Rr';
Tr = repmat(tr,1,size(Ww,2));

Wr  = Rrt*(Ww-Tr); % points wrt robot

% camera frame
% C  = Cam.C;
% tc = C(1:3);
% qc = C(4:7);
% Rct = ori2mat(qc)';
[tc,Rc] = getTR(Cam);
Rct = Rc';
Tc  = diag(tc)*ones(size(Wr));

Wc  = Rct*(Wr-Tc); % points wrt camera

% test of depth
depth = Wc(3,:);
dtest = (depth>=Cam.dlim(1))&(depth<=Cam.dlim(2));

% test of field of view
hview = Wc(1,:)./depth;
vview = Wc(2,:)./depth;
vtest = (abs(hview)<Cam.nfv(1))&(abs(vview)<Cam.nfv(2));

% both tests
test = dtest+vtest;

% find winners and build ids vector
cand  = find(test==2);
visLm = world(:,cand);


