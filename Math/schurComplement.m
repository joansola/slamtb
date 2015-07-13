function [S,iC] = schurComplement(M, m1, sqrt)

%   M = [A B ; B' C]
%
%   S = A - B/C*B'

n = size(M,1);

% Complementary range
m2 = setdiff(1:n,m1);

R = chol(M([m2 m1],[m2 m1]));

n1 = numel(m1);
n2 = n-n1;

r1 = 1:n1;
r2 = n1 + (1:n2);

if nargin < 3 || ~sqrt

    % Return full version of Schur complement
    S = R(r1,r1)' * R(r1,r1);
    
    if nargout == 2
        iCsqrt = R(r2,r2)^-1;
        iC = iCsqrt * iCsqrt';
    end
    
else
    
    % Return square root factor of Schur complement
    S = R(r1,r1);

    if nargout == 2
        iC = R(r2,r2)^-1;
    end
    
end
