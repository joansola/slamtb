function [q,Qq,Qw] = qw2q(q,w,T)

% QW2Q Quaternion evolution function from angular rates
%   Q = QW2Q(Q,W,T) gives the quaternion evolution
%   resulting from a motion at W rad/s during T seconds.
%
%   [Q,Qq,Qw] = QW2Q(...) gives the Jacobians wrt Q and W.
%
%   See also VW2V

Om = w2omega(w);
q  = q + .5*T*Om*q;
q  = q/sqrt(q'*q);

if nargout > 1
    Qq = eye(4)+0.5*T*Om;
    Qw = 0.5*T*q2pi(q);
end
