function [X,Y] = cov2elli(x,P,ns,NP)

% COV2ELLI  Ellipse points from mean and covariances matrix.
%   COV2ELLI(M,P,NS,NP) returns X and Y coordinates of the NP
%   points of the the NS-sigma bound ellipse of the Gaussian defined by
%   mean XM and covariances matrix P.



persistent cercle

if isempty(cercle)
        alpha = 2*pi/NP*(0:NP);
        cercle = [cos(alpha);sin(alpha)];
end


[U,D,V]=svd(P);
d = sqrt(D);

% circle -> aligned ellipse -> rotated ellipse -> ns-ellipse
ellip = ns*U*d*cercle;

% output ready for plotting (X and Y line vectors)
X = x(1)+ellip(1,:);
Y = x(2)+ellip(2,:);
