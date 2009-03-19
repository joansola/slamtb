function [X,Y] = cov2elli(x,P,ns,NP)

% COV2ELLI  Ellipse points from mean and covariances matrix.
%   [X,Y] = COV2ELLI(X0,P,NS,NP) returns X and Y coordinates of the NP
%   points of the the NS-sigma bound ellipse of the Gaussian defined by
%   mean X0 and covariances matrix P.
%
%   The ellipse can be plotted in a 2D graphic by just creating a line
%   with line(X,Y).
%
%   See also COV3ELLI, LINE.



persistent cercle

if isempty(cercle)
    alpha = 2*pi/NP*(0:NP);
    cercle = [cos(alpha);sin(alpha)];
end


[U,D]=svd(P);
d = sqrt(D);

% circle -> aligned ellipse -> rotated ellipse -> ns-ellipse
ellip = ns*U*d*cercle;

% output ready for plotting (X and Y line vectors)
X = x(1)+ellip(1,:);
Y = x(2)+ellip(2,:);
