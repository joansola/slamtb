function [Rwr,Rrw] = a2rwr(a)

% A2RWR 2D orientation angle to rotation matrix conversion
%   R_WR = A2RWR(A) returns rotation matrix world to robot
%   corresponding to robot orientation angle A
%
%   [R_WR,R_RW] = A2RWR(A) gives also the inverse, i.e. the
%   rotation matrix robot to world.

Rwr = [cos(a) sin(a);-sin(a) cos(a)];
Rrw = Rwr';
