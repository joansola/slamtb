function [z,Z,iZ,MD2] = innovation(y,R,e,E)

% INNOVATION  Innovation of an observation.
%   [z,Z] = INNOVATION(y,R,e,E) computes innovation z and innovation's
%   covariances matrix Z from a measurement N{y,R} to the expectation N{e,E}
%   as
%
%     z = y - e
%     Z = R + E
%
%   [z,Z,iZ,MD2] = INNOVATION(...) returns also the inverse of the
%   innovation covariance iZ and the squared Mahalanobis distance MD2.
%
%   See also MAHALANOBIS.

z = y - e;
Z = R + E;

if nargout >= 3
    iZ = inv(Z);
    if nargout == 4
        MD2 = z'*iZ*z;
    end
end

