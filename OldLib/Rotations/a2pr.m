function [p,r] = a2pr(a,b)

% A2PR Accelerometer readings to pitch and roll angles
%   [P,R]=A2PR(A) returns pitch and roll angles of an accelerometer that is
%   giving readings A. Yaw is not observable)
%
%   [P,R]=A2PR(A,B) accepts sensors biases B.

if nargin == 2
    a = a-b;
end

n = a/norm(a);

p = -asin(n(1));
r =  asin(n(2)/cos(p));

