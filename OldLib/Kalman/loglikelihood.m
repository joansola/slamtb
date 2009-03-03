function Ll = loglikelihood(y,R,ye,P,H)

%LOGLIKELIHOOD  Likelihood of gaussian hypothese given gaussian measure. 
%
%   LI = LOGLIKELIHOOD(Y,R,YE,P,H) is the Mahalanobis distance between
%   the true measure Y and the expected measure YE=h(X). R is the
%   covariances matrix for Y; P is for X; H is the jacobian of h(.)
%   evaluated at the last best estimate of X. It is calculated as:
%
%   LI = -.5*((Y-YE)'*(H*P*H'+R)^-1*(Y-YE))
% 
%
%   See also LIKELIHOOD, KALMANCORRECT
%

z = y - ye;   % Innovation
S = H*P*H'+R; % Covariances matrix of the innovation

Li = -.5*(z'*S^-1*z);