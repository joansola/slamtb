function [c,C] = pluckerConstraint(L)

% PLUCKERCONSTRAINT  Plucker constraint
%   C = PLUCKERCONSTRAINT(L) returns the value of the Plucker constraint,
%   which has to be equal to zero. If L=[a;b], this constraint is
%
%       C = a'*b = 0
%
%   [C,Cl] = PLUCKERCONSTRAINT(...) returns the Jacobian wrt L.


a = L(1:3);
b = L(4:6);

c = dot(a,b);

if nargout > 1
    
    C = [b;a]';
    
end

return

%%

syms L1 L2 L3 L4 L5 L6 real
L = [L1 L2 L3 L4 L5 L6]';

[c,C] = pluckerConstraint(L)

C - jacobian(c,L)
