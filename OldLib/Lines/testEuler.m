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
K = [au 0 u0 0
    0 av v0 0
    0 0 1 0]

%% camera frame
e = deg2rad([0;0;0]);
R = e2R(e);
t = [0;0;0];

H = [R' -R'*t;0 0 0 1];

%% camera projection matrix
Pe = K*H;

%% plucker camera
P = pluckerCamera(Pe);

%% project line
l = P*L


%%
l = projectPluckerEuler(t,e,k,L)

%% line in rho-theta coordinates

rt = hm2rt(l);
rho = rt(1)
thetaDeg = rad2deg(rt(2))


%%
ih = 1;

L = retroProjectPluckerEuler(t,e,k,l,ih)

l = projectPluckerEuler(t,e,k,L)

L = retroProjectPluckerEuler(t,e,k,l,ih)

L = retroProjectPluckerEuler(t,e,k,l,2*ih)
