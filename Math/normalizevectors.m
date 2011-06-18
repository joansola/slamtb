x = randn(2,1); x = normvec(x);
P = .5*(rand(2)-.5); P = P*P';
C = eye(2);
c = [0;0];

% apply explicit constraint
[x1, X1_x] = normvec(x);
P1 = X1_x*P*X1_x';

% change vector, keep covariance
x2 = [0;1];
P2 = P1;

% apply explicit constraint
[x3, X3_x2] = normvec(x2);
P3 = X3_x2*P2*X3_x2';

% apply implicit constraint y = norm(x) = 1
[n, H] = vecnorm(x);
z = 1-n;
Z = H*P*H';
K = P*H'/Z;
x4 = x + K*z;
P4 = P - K*H*P;

% svds
% [V,S] = svd(P);
% [V1,S1] = svd(P1);
% [V2,S2] = svd(P2);
% [V3,S3] = svd(P3);

% graphics
figure(1);cla
axis equal
axis([-2 2 -2 2])
line('xdata',0,'ydata',0,'marker','+')
[X,Y] = cov2elli(c,C,1,50);
line('xdata',X,'ydata',Y,'color',[.5 .5 .5])
[X,Y] = cov2elli(x,P,1,50);
line('xdata',X,'ydata',Y,'color','r')
[X,Y] = cov2elli(x1,P1+eps*eye(2),1,50);
line('xdata',X,'ydata',Y,'color','g')
% [X,Y] = cov2elli(x2,P2+eps*eye(2),1,50);
% line('xdata',X,'ydata',Y,'color','b')
% [X,Y] = cov2elli(x3,P3+eps*eye(2),1,50);
% line('xdata',X,'ydata',Y,'color','m')
[X,Y] = cov2elli(x4,P4+eps*eye(2),1,50);
line('xdata',X,'ydata',Y,'color','b')
