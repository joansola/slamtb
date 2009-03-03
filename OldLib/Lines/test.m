clear,clc

%% Plucker line
A = [1 0 1 1]'; % the line  passes  over  this point
B = [1 0 0 0]'; % the line is parallel to this axis
L  = points2plucker(A,B)

%% Camera
u0 = 0;
v0 = 0;
au = 1;
av = 1;
k = [u0 v0 au av];

%% camera frame
e = deg2rad([10;20;30]);
q = e2q(e);
R = e2R(e);
t = [0;0;0];

C = [t;q];

[it,iq] = invTQ(t,q);

iC = [it;iq];

H = pluckerTransform(iC);

%% plucker camera
K = pluckerCamera(k);

%% camera projection matrix
P = K*H;

%% project line
l = P*L


%%
l = projectPlucker(C,k,L)

%% line in rho-theta coordinates

rt = hm2rt(l);
rho = rt(1)
thetaDeg = rad2deg(rt(2))


%%
beta = [1;0];

L = retroProjectPlucker(C,k,l,beta)

l = projectPlucker(C,k,L)

L = retroProjectPlucker(C,k,l,beta)

L = retroProjectPlucker(C,k,l,2*beta)
