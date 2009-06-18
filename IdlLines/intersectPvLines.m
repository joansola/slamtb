function [t,p1,p2] = intersectPvLines(l1,l2)

% INTERSECTPVLINES  Intersect two point-vector lines.
%   [T,P1,P2] = INTERSECTPVLINES(L1,L2) intersects the two point-vector
%   lines L1=[E1,V1] and L2=[E2,V2], and returns a vector of abscissas
%   T=[T1;T2], and two intersection points P1 and P2, so that
%
%       P1 = E1 + T1*V1
%       P2 = E2 + T2*V2
%
%   If the lines intersect, we have the intersection point P = P1 = P2.
%   Otherwise, P1 and P2 are the points of the lines that are closest to
%   the other line, that is, the line passing over P1 and P2 is orthogonal
%   to both L1 and L2.
%
%   See also INTERSECTPPLINES, PPLINE2PVLINE.

e1 = l1(1:3); % point in line
v1 = l1(4:6);
e2 = l2(1:3);
v2 = l2(4:6);

A = [-v1'*v1 v2'*v1;-v2'*v1 v2'*v2];
b = [v1';v2']*(e1-e2);

t = A^-1*b;

if nargout > 1
    p1 = e1 + t(1)*v1;
    p2 = e2 + t(2)*v2;
end

