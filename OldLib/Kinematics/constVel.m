function [xo,Fx,Fu] = constVel(x,Ts,u)

% CONSTVEL  Constant velocity model for any dimension.
%   Xo = CONSTVEL(X) performs one constant velocity step from 
%   state vector X=[x;v] to Xo=[xo,v] so that xo=x+Ts*v with Ts=1
%
%   Xo = CONSTVEL(X,Ts) allows for the specification of the
%   sampling time Ts.
%
%   Xo = CONSTVEL(X,TE,U) additionally accepts a velocity
%   perturbation so that 
%
%      xo = x + sqrt(Ts)*v
%      vo = v + U
%
%   [Xo,Fx,Fu] = CONSTVEL(...) return the function derivatives
%   wrt. X and U.

n  = length(x);
if nargin < 3
    if nargin < 2
        Ts = 1;
    end
    u = zeros(n/2,1);
end

m  = length(u);
if m ~= n/2 
    error('Velocity perturbation dimension must be one half of state dimension')
end
I3 = eye(n/2);
Z3 = zeros(n/2);

Fx = [I3 Ts*I3;Z3 I3];

Fu = sqrt(Ts)*[Z3;I3];

xo = Fx*x + Fu*u;
