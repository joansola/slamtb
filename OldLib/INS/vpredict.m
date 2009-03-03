function [v,Vv,Va] = vpredict(v,a,dt)

% VPREDICT Velocity prediction
%   VPREDICT(V) performs the time update V = V
%
%   VPREDICT(V,A,DT) performs the time update V = V + A*DT
%
%   [V,Vv,Va] = ... returns the Jacobian matrices wrt velocity V and 
%   acceleration A.
%
%   See also SPREDICT, RPREDICT, QPREDICT, BPREDICT, INVACC

Vv = eye(length(v));

if nargin == 3
    v  = v + a*dt;
    Va = dt*Vv;
end

