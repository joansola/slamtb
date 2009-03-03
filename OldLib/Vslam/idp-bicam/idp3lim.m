function [X,Y,Z] = idp3lim(idp,IDP,ns,NP)

persistent cercle

if isempty(cercle)
    alpha = 2*pi/NP*(0:NP);
    cercle = [...
        cos(alpha)    cos(alpha)
        sin(alpha)    zeros(1,NP+1)
        zeros(1,NP+1) sin(alpha)];
end

% disclose idp
% x0  = idp(1:3);
% py  = idp(4:5);
% rho = idp(6);

% 3D point and covariance
[p,Pidp] = idp2p(idp);
P = Pidp*IDP*Pidp';

[X,Y,Z] = cov3elli(p,P,ns,NP);

%% build lim

