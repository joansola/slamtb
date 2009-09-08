function p = gauss(x,m,P)

% GAUSS gaussian probability distribution funciton
%   
%   P = GAUSS(X;M;P) computes gaussian distribuiton value for a variable X
%   with mean M and covariances matrix P. X can be a column n-vector or a
%   m-by-n matrix, in which case each column is treated as a vector and the
%   result is a 1-by-m vector of probabilities.

n  = max(size(P));
if n~=min(size(P))
    error('P must be a square matrix')
end
if n ~= size(x,1)
    error('x and P are not of the same order')
end
if n ~= size(m,1)
    error('m and P are not of the same order')
end

if size(x,2) == 1
    % single input
    p = sqrt(2*pi)^(-n)/det(P)*exp(-(x-m)'*inv(P)*(x-m)/2);
else
    % multiple inputs
    dx = x-repmat(m,1,size(x,2));
    p  = sqrt(2*pi)^(-n)/det(P)*exp(diag(-dx'*inv(P)*dx/2));
end
