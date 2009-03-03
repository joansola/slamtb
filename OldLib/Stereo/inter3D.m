function [pi,p1,p2] = inter3D(o1,v1,o2,v2)

% INTER3D  best pseudo intersect point of two 3D lines
%   PI = INTER3D(O1,V1,O2,V2) is the central point of the segment
%   that is orthogonal to lines L1 and L2, these lines Li being
%   defined by their respective origin and direction vectors Oi
%   and Vi given as inputs. This central point is the best
%   approximation of the 3D intersection point of two 3D lines
%   when these lines don't effectively meet.
%
%   [PI,P1,P2] = INTER3D(...) returns also the two points in both
%   lines that are closest to PI. See the algorithm below for an
%   interpretation of P1 and P2.
%
%   The algorithm is as follows. Both lines are written in
%   parametrized form with parameters s1 and s2:
%
%     L1:  p1 = o1 + s1*v1              (1)
%     L2:  p2 = o2 + s2*v2
%
%   The orthogonality constraint is imposed:
%
%     (p1-p2)'*v1 = 0                   (2)
%     (p1-p2)'*v2 = 0
%
%   which leads to the linear system on S = [s1 s2]':
%
%     A*S = B
%
%   with
%  
%     A = [v1'*v1 -v1'*v2          B = [(o2-o1)'*v1
%          v1'*v2 -v2'*v2]              (o2-o1)'*v2]
%
%   that is solved via S = inv(A)*B , S fed into (1) to solve
%   for p1 and p2, and the intersection point pi is finally
%
%     pi = (p1+p2)/2

% (c) 2006 Joan Sola @ LAAS-CNRS

nv1_2 = v1'*v1;
nv2_2 = v2'*v2;
v1v2  = v1'*v2;
o2o1t = (o2 - o1)';

A = [nv1_2 -v1v2 ; v1v2 -nv2_2];
B = [o2o1t*v1;o2o1t*v2];

L = inv(A)*B;

p1 = o1 + L(1)*v1;
p2 = o2 + L(2)*v2;

pi = (p1 + p2)/2;
