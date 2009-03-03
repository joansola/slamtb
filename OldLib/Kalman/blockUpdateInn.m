function blockUpdateInn(r1,r2,H1,H2,Inn,method)

% BLOCKUPDATEINN  Kalman block update given innovation
%   BLOCKUPDATEINN(r1,r2,H1,H2,Inn) performs
%   a non linear Kalman update where:
%     r1 and r2 define the ranges of the two blocks.
%     x1 = X(r1) and x2 = X(r2) are the two blocks.
%     Map is a global structure with 
%       X and P:  filter state and covariances matrix.
%       used:     indices to used 3D positions
%     H1 and H2 are the jacobians of y=h(X) wrt x1 and x2.
%     Inn is the innovation containing:
%       z  = y-h(X):     innovation
%       Z  = H*P*H' + R: innovation covariance
%       iZ = Z^-1:       inverse of innovation
%
%   BLOCKUPDATEINN(...,'method') performs the
%   covariance update with 'method':
%     'simple' is P = P - K*H*P
%     'symmet' is P = P - K*Z*K'
%   where
%     K is the Kalman gain
%     P is the used part of Map.P
%     H is the appropiated Jacobian: H = [H1 H2]
%
%   See also BLOCKUPDATE, BLOCKPREDICT, INNOVATION

global Map

if isfield(Map,'useType') && strcmp(Map.useType,'range')
    mr = find(Map.used);
else
    mloc = Map.used(Map.used~=0)';
    sr   = 1:(loc2state(mloc(1))-1);
    mr   = [sr loc2range(mloc)]; % All map range
end

PHt = Map.P(mr,r1)*H1'+Map.P(mr,r2)*H2';

K   = PHt * Inn.iZ;

Map.X(mr) = Map.X(mr) + K*Inn.z;

if (nargin < 6) || strcmp(method,'symmet')
    Map.P(mr,mr) = Map.P(mr,mr) - K*Inn.Z*K';
    
elseif strcmp(method,'simple')
    PP = K*PHt';
    Map.P(mr,mr) = Map.P(mr,mr) - K*PHt';
    Map.P(mr,mr) = 0.5*(Map.P(mr,mr) + Map.P(mr,mr)');
    
else
    error('Unknown update method');
    
end

