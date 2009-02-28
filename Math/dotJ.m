function [d,Da,Db] = dotJ(a,b)

% DOTJ Dot product with Jacobian return
%   D = DOTJ(A,B) is equivalent to DOT(A,B).
%
%   [D,Da,Db] = DOTJ(A,B) returns the Jacobians of D wrt A and B:
%
%       Da = B'
%       Db = A'

d = dot(a,b);
Da = b';
Db = a';
