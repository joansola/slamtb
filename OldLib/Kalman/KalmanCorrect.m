function [P,X,K,V] = KalmanCorrect(P,X,Y,H,R,method,Ye)

% KALMANCORRECT  measure correction step for Kalman Filter
%
%   For a measures model:
%
%   Y = H*x + v
%
%   with X = E{x}
%        P = E{(x-X)(x-X)'}
%        R = E{vv'}
%
%   [P,X] = KALMANCORRECT(P,X,Y,H,R) realizes a linear measure
%   update of state vector statistics X and P from measures Y,
%   model matrix H and measures noise covariances R, using
%   the simple form P+ = P-KHP for the covariance update.
%
%   [P,X] = KALMANCORRECT(P,X,Y,H,R,METHOD) uses METHOD to
%   update P. METHOD is a string of either
%   'khp' (P+=P-KHP) or 'kzk' (P+=P-K*(HPH'+R)*K').
%
%   [P,X] = KALMANCORRECT(P,X,Y,H,R,METHOD,YE) is the same,
%   except that an estimated measure YE = h(X) is provided
%   to allow for non linear measure updates, where:
%
%   Y = h(x) + v
%
%   with H : the jacobian of h(x) at point X.
%
%   [P,X,K] = KALMANCORRECT(...) returns also the gain matrix K.
%
%   [P,X,K,V] = KALMANCORRECT(...) returns also the likelyhood V:
%
%       V = 1/(2*pi*det(Z))^(n/2)*exp(-.5*(z)'*inv(Z)*(z))
%
%   where z = Y-h(X) is the innovation and Z = HPH'+R
%
%
%   See also KALMANPREDICT

if nargin < 5
    error('Not enough input arguments')
end

HP     = H*P;
HPHt   = HP*H';
HPHtR  = HPHt+R;
iHPHtR = inv(HPHtR);
PHt    = HP';

K      = PHt*iHPHtR;

if nargin == 5
    method = 's';
end

% Covariances update
switch method
    case 'khp'
        P = P-K*HP;
    case 'kzk'
        P = P-K*HPHtR*K';
    otherwise
        P = P-K*HP;
end

% State update
if nargin < 7
    Ye = H*X;
end
X = X + K*(Y-Ye);

if nargout == 4
    n  = max(size(P));
    z = Y-Ye;
    e = 20-.5*(z)'*inv(HPHtR)*(z);
    V = 1/(2*pi)^(n/2)/det(HPHtR)*exp(e);
end