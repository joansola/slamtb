function [X,Y,Z] = idp3elli(idp,IDP,ns,NP)

% 3D point and covariance
[p,Pidp] = idp2p(idp);
P = Pidp*IDP*Pidp';

[X,Y,Z] = cov3elli(p,P,ns,NP);


