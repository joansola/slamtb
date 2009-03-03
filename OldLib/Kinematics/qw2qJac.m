function [Fq,Fw] = qw2qJac(q,w,T)

% QW2QJAC Jacobians of QW2Q

Fq = eye(4)+0.5*T*w2omega(w);
Fw = 0.5*T*squat2pi(q);

% OK tested