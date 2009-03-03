function blockUpdate(r1,r2,H1,H2,y,R,ye,method)

% BLOCKUPDATE  Sparse Kalman update with two blocks
%   BLOCKUPDATE(r1,r2,H1,H2,y,R,ye) performs
%   a non linear Kalman update where:
%     y  = h(x1,x2) + v is the observation
%     r1 and r2 define the ranges of the two blocks.
%     x1 = X(r1) and x2 = X(r2) are the two blocks.
%     Map is a global structure with 
%       X and P:  filter state and covariances matrix.
%       m:        current map size
%     H1 and H2 are the jacobians of y=h(X) wrt x1 and x2.
%     R  is the covariance of the noise v.
%     ye is the expected observation.
%
%   BLOCKUPDATE(...,'method') performs the
%   covariance update with 'method':
%     'simple' is Pm = Pm - K*HH*Pm
%     'symmet' is Pm = Pm - K*Z*K'
%   where 
%     Pm  = Map.P(1:Map.m,1:Map.m)
%     K is the Kalman gain
%     Z   = HH*PP*HH' + R
%     HH  = [H1 H2]
%     PP  = Map.P([r1 r2],[r1 r2])
%
%   See also BLOCKPREDICT, INNOVATION, LIKELIHOOD, GAUSS

global Map

% mr = [1:Map.m]; % current map range
mloc = Map.used(Map.used~=0)';
mr   = mloc2mrange(mloc);
mr   = [1:PDIM mr(:)'];

PHt = Map.P(mr,r1)*H1'+Map.P(mr,r2)*H2';
HH  = [H1 H2];
PP  = Map.P([r1 r2],[r1 r2]);

[z,Z,iZ] = innovation(PP,y,HH,R,ye);

K    = PHt * iZ;

Map.X(mr) = Map.X(mr) + K*z;

if (nargin < 8) | strcmp(method,'symmet')
    Map.P(mr,mr) = Map.P(mr,mr) - K*Z*K';
elseif strcmp(method,'simple')
    Map.P(mr,mr) = Map.P(mr,mr) - K*PHt';
else
    error('Unknown update method');
end

