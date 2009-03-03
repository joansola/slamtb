
% DQTEST Test of the derivative of Q function
%   For angular rates and quaternion orientations.

T = .01; % sample time

w  = 1; % angular rate
a  = [2;-2;1]; % rotation axis, body frame
a = a/sqrt(a'*a);

de = a*w*T; % rotation increment, body frame

x1 = [1 0 0]'; % body canonical base
x2 = [0 1 0]'; 
x3 = [0 0 1]'; 

q  = [1 2 3 4]';
q  = q/norm(q); % initial body orientation

R = q2R(q); % body-to-world rotation matrix

ax  = [[0;0;0] R*a];  % rotation axis, world frame
xi1 = [[0;0;0] R*x1]; % body axes, worls frame
xi2 = [[0;0;0] R*x2];
xi3 = [[0;0;0] R*x3];

% Quaternion test
xx1 = R*x1;
xx2 = R*x2;
xx3 = R*x3;
for t = 1:5/T
    Om  = w2omega(de);
    q   = q+0.5*Om*q;
    R   = q2R(q);
    xx1 = [xx1 R*x1];
    xx2 = [xx2 R*x2];
    xx3 = [xx3 R*x3];
end

% plots
plot3(xx1(1,:),xx1(2,:),xx1(3,:),'r')
axis equal
axis([-1 1 -1 1 -1 1])
view(-50,25)
xlabel('x');ylabel('y');zlabel('z');
box
grid
hold on
plot3(xx2(1,:),xx2(2,:),xx2(3,:),'g')
plot3(xx3(1,:),xx3(2,:),xx3(3,:),'b')
plot3(ax(1,:),ax(2,:),ax(3,:),'k')
plot3(xi1(1,:),xi1(2,:),xi1(3,:),'r')
plot3(xi2(1,:),xi2(2,:),xi2(3,:),'g')
plot3(xi3(1,:),xi3(2,:),xi3(3,:),'b')
hold off
