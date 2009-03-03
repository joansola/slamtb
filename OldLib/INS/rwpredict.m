function [x,Fx,Fu] = rwpredict(x,u)

% RWPREDICT Random walk prediction and Jacobians
%   [x,Fx,Fu] = RWPREDICT(x,u)

x  = x + u;
Fx = eye(length(x));
Fu = Fx;
