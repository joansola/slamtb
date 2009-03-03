function [dp,V,V1] = dvo(x,x1)

% DVO Visual odometry incremental pose observation function.
%   DVO(X,X1) is the incremental pose from states X1 = x(k-1) to X = x(k)
%  
%   [DP,V,V1] = DVO(...) also returns the Jacobians wrt X and X1.
%
%   The states X = x(k) and X1 = x(k-1) are 16-vectors of the form
%
%       [r v q ba bg]'
%
%   where
%       r  is the 3D position
%       v  is the 3D velocity
%       q  is the orientation quaternion in ENU frame
%       ba is the 3D accelerometer bias
%       bg is the 3D gyrometer bias
%
%   however, only r(k), r(k-1), q(k) and q(k-1) are actually used.
%
%   The incremental pose DP is expressed in the local frame at time (k-1) 
%   and comes in the format:
%
%       [dx dy dz r p y]'
%
%   where 
%       {dx dy dz} are the position increments in local frame, 
%       {r p y} are roll, pitch and yaw, the rotation from (k-1) to (k).
%
%   See also DEUPDATE, SPREDICT, ENU, VO

r  = x(1:3);
% v  = x(4:6);
q  = x(7:10);
r1 = x1(1:3);
q1 = x1(7:10);

F1.X = [r1;q1]; % frame at x(k-1), the reference for VO
F1 = updateFrame(F1);

% Position increment and Jacobians
[dr,DRf1,DRr] = toFrame(F1,r);
DRr1 = DRf1(:,1:3);
DRq1 = DRf1(:,4:7);

% Orientation increment and Jacobians
[q1c,Q1Cq1]     = q2qc(q1);
[dq,Dq1c,Dq]    = qProd(q1c,q);
[e,Edq]         = q2e(dq);

% Composed Jacobians
Eq  = Edq*Dq;
Eq1 = Edq*Dq1c*Q1Cq1;

% Null Jacobians
Z33 = zeros(3);
Z34 = zeros(3,4);

% VO measurement
dp  = [dr;e];

% VO Jacobians
V  = [DRr Z33 Z34 Z33 Z33
      Z33 Z33 Eq  Z33 Z33];
    
V1 = [DRr1 Z33 DRq1 Z33 Z33
      Z33  Z33 Eq1  Z33 Z33];
    

