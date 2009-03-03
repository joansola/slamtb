
% ODO3TEST Test of odo3 function
%   For euler angles and quaternion orientations.

T = .01; % sample time

v  = 1; % linear speed
w  = 1; % angular rate
a  = [0;1;1]; % rotation axis
a = a/sqrt(a'*a);
de = a*w*T; % rotation
dx = v*T;
% dx = [1;0;0]*v*T;  % translation and direction

% Euler test
% e = [0;0;0];
% x = [0;0;0];
% xx = [0;0;0];
% for t = 1:6.3/T
% %     [x,e] = odo3(x,e,dx,de);
%     Re = [x;e];
%     Re = odo3(Re,dx,de);
%     x = Re(1:3);
%     e = Re(4:end);
%     xx = [xx x];
%     e = eulerFormat(e);
% end
% plot3(xx(1,:),xx(2,:),xx(3,:))
% box
% grid
% axis equal
% 
% pause(5)


% Quaternion test
q  = [1;0;0;0];
x  = [0;0;0];
xx = [0;0;0];
for t = 1:5/T
    Rq.X = [x;q];
    Rq = odo3(Rq,dx,de);
    x  = Rq.X(1:3);
    q  = Rq.X(4:end);
    xx = [xx x];
end

plot3(xx(1,:),xx(2,:),xx(3,:))
xlabel('x');ylabel('y');zlabel('z');
box
grid
axis equal
view(-50,25)
