function [gp,Gx] = gps(x)

% GPS  Global positioning system observation function
%   [G,Gx] = GPS(X) is the GPS observation of the INS state X. This state
%   is
%
%       r = position
%       v = velocity
%       ... other states
%
%   the observation function is simply G = r. the Jacobian is also
%   returned.

gp = x(1:3);
Gx = zeros(3,length(x));
Gx(1:3,1:3) = eye(3);