function [r,Rr,Rv,Ra] = rpredict(r,v,a,dt)

% RPREDICT Position prediction.
%   RPREDICT(R,V,DT) performs the time update R = R + V*DT.
%
%   RPREDICT(R,V,A,DT) considers R = R + V*DT + 1/2*A*DT instead.
%
%   [R,Rr,Rv,Ra] = ... returns Jacobian matrices wrt position R, velocity V
%   and acceleration A.
%
%   See also VPREDICT, QPREDICT.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin == 3
    dt = a;
    r  = r + v*dt;
    Rr = eye(length(r));
    Rv = dt*Rr;
    Ra = zeros(3);

elseif nargin == 4
    r  = r + v*dt + .5*a*dt^2;
    Rr = eye(length(r));
    Rv = Rr*dt;
    Ra = 0.5*Rr*dt^2;

end









