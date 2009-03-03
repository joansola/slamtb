function p = gauss(x,m,P)

% GAUSS gaussian probability distribution funciton
%   
%   P=GAUSS(X;M;P) computes gaussian distribuiton value
%   for a variable X with mean M and covariances matrix P

n  = max(size(P));
if n~=min(size(P))
    error('P must be a square matrix')
end
if n ~= size(x,1)
    error('x and P are not of the same order')
end

% c  =  1/sqrt((2*pi)^n*det(P));
% e  =  -.5*(x-m)'*inv(P)*(x-m);
% g  =  exp(e);
% p  =  c*g;

p = sqrt(2*pi)^(-n)/det(P)*exp(-(x-m)'*inv(P)*(x-m)/2);

