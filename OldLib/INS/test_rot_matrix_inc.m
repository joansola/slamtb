%%

q  = normquat([1;2;3;4]);
dw = [.001;.002;.003];
[dq,DQdw] = dw2dq(dw);
[q1,Q1q,Q1dw] = qdw2q(q,dw);

R  = q2R(q);
R1 = q2R(q1);
W  = hat(dw);
R2 = R*(eye(3)+W);

R
R1
R2
R1*R2'

