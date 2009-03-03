% rotation and derivative

v = [0 0 1]'; % current rotation vector
w = [1 0 0]'; % angular speed in body frame
dt = 0.02;    % sampling time

R1 = v2R(v);
R2 = R1;
R3 = R1;

% figure(1)
clf
wg = wing;
wgh1 = patch;
wgh2 = patch;
wgh3 = patch;
set(wgh1,'vertices',wg.vert0*R1','faces',wg.faces,'facecolor','none','edgecolor','r')
set(wgh2,'vertices',wg.vert0*R2','faces',wg.faces,'facecolor','none','edgecolor','g')
set(wgh3,'vertices',wg.vert0*R3','faces',wg.faces,'facecolor','none','edgecolor','b')
axis([-1 1 -1 1 -1 1]/2)
axis square

for t = 0:dt:5
    
    % product of matrices
    R1 = R1*v2R(w*dt);
    
    % addition of matrices
    R2 = R2 + R2*hat(w)*dt;
    [U,D,V] = svd(R2);
    R2 = U*V';
    
    % derivative from Y. Ma
    R3 = R3 + dt*hat(w)*R3;
    [U,D,V] = svd(R3);
    R3 = U*V';
    
    % animations
    wg.vert = wg.vert0*R1';
    set(wgh1,'vertices',wg.vert)
    wg.vert = wg.vert0*R2';
    set(wgh2,'vertices',wg.vert)
    wg.vert = wg.vert0*R3';
    set(wgh3,'vertices',wg.vert)
    drawnow
end