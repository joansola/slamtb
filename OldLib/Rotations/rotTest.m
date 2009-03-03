% ROTTEST Rotations test, on quaternions and euler angles

syms r p y real % roll, pitch, yaw
e = [r;p;y]; % euler angles vector
q = e2q(e);  % equivalent quaternion

Re = e2R(e); 
Rq = q2R(q);

% compare both rotation matrices
errorMat = simple(Re-Rq) 

syms x y z real
p = [x y z]'; % point in space
rq = qRot(p,q);
rRe = Re*p;
rRq = Rq*p;

% compare quaternion-rotated point to matrix-rotated point
errorRot = simple(rq-rRe) 

