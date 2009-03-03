function [s,St,Sp] = txp(t,p)

% TXP  Cross product with Jacobians output
%
%   WARNING! ==> Deprecated function. Use CROSSJ instead. <==
%
%   TXP(T,P) is equivalent to CROSS(T,P). Its name comes from the fact that
%
%       CROSS(T,P) = [T]_x * P
%
%   where [T]_x = hat(T).
%
%   [S,St,Sp] = TXP(T,P) returns the Jacobians wrt T and P.
%
%   See also CROSSJ, CROSS, HAT.

warning('Function TXP is deprecated. Use CROSSJ instead.')

s = cross(t,p);

if nargout > 1
    
    Sp = hat(t);

    St = -hat(p);

end

return

%%

syms x y z p1 p2 p3 real
t = [x;y;z];
p = [p1;p2;p3];

[s,St,Sp] = txp(t,p)

St - jacobian(s,t)

Sp - jacobian(s,p)

