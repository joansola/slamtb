function [p,plo,pup] = gamcdf(x,a,b,pcov,alpha)
%GAMCDF Gamma cumulative distribution function.
%   P = GAMCDF(X,A,B) returns the gamma cumulative distribution function
%   with shape and scale parameters A and B, respectively, at the values in
%   X.  The size of P is the common size of the input arguments.  A scalar
%   input functions as a constant matrix of the same size as the other
%   inputs.
%
%   Some references refer to the gamma distribution with a single
%   parameter.  This corresponds to the default of B = 1. 
%
%   [P,PLO,PUP] = GAMCDF(X,A,B,PCOV,ALPHA) produces confidence bounds for
%   P when the input parameters A and B are estimates.  PCOV is a 2-by-2
%   matrix containing the covariance matrix of the estimated parameters.
%   ALPHA has a default value of 0.05, and specifies 100*(1-ALPHA)%
%   confidence bounds.  PLO and PUP are arrays of the same size as P
%   containing the lower and upper confidence bounds.
%
%   See also GAMFIT, GAMINV, GAMLIKE, GAMPDF, GAMRND, GAMSTAT, GAMMAINC.

%   GAMMAINC does computational work.

%   References:
%      [1] Abramowitz, M. and Stegun, I.A. (1964) Handbook of Mathematical
%          Functions, Dover, New York, section 26.1.
%      [2] Evans, M., Hastings, N., and Peacock, B. (1993) Statistical
%          Distributions, 2nd ed., Wiley.

%   Copyright 1993-2004 The MathWorks, Inc. 
%   $Revision: 2.12.2.4 $  $Date: 2004/12/24 20:46:50 $

if nargin < 2
    error('stats:gamcdf:TooFewInputs',...
          'Requires at least two input arguments.');
elseif nargin < 3
    b = 1;
end

% More checking if we need to compute confidence bounds.
if nargout > 1
    if nargin < 4
        error('stats:gamcdf:TooFewInputs',...
              'Must provide covariance matrix to compute confidence bounds.');
    end
    if ~isequal(size(pcov),[2 2])
        error('stats:gamcdf:BadCovariance',...
              'Covariance matrix must have 2 rows and columns.');
    end
    if nargin < 5
        alpha = 0.05;
    elseif ~isnumeric(alpha) || numel(alpha) ~= 1 || alpha <= 0 || alpha >= 1
        error('stats:gamcdf:BadAlpha',...
              'ALPHA must be a scalar between 0 and 1.');
    end
end

% Return NaN for out of range parameters.
a(a <= 0) = NaN;
b(b <= 0) = NaN;
x(x < 0) = 0;

try
    z = x ./ b;
    p = gammainc(z, a);
catch
    error('stats:gamcdf:InputSizeMismatch',...
          'Non-scalar arguments must match in size.');
end
p(z == Inf) = 1;

% Compute confidence bounds if requested.
if nargout >= 2
    % Approximate the variance of p on the logit scale
    logitp = log(p./(1-p));
    dp = 1 ./ (p.*(1-p)); % derivative of logit(p) w.r.t. p
    da = dgammainc(z,a) .* dp; % dlogitp/da = dp/da * dlogitp/dp
    db = -exp(a.*log(z)-z-gammaln(a)-log(b)) .* dp; % dlogitp/db = dp/db * dlogitp/dp
    varLogitp = pcov(1,1).*da.^2 + 2.*pcov(1,2).*da.*db + pcov(2,2).*db.^2;
    if any(varLogitp(:) < 0)
        error('stats:gamcdf:BadCovariance',...
              'PCOV must be a positive semi-definite matrix.');
    end
    
    % Use a normal approximation on the logit scale, then transform back to
    % the original CDF scale
    halfwidth = -norminv(alpha/2) * sqrt(varLogitp);
    explogitplo = exp(logitp - halfwidth);
    explogitpup = exp(logitp + halfwidth);
    plo = explogitplo ./ (1 + explogitplo);
    pup = explogitpup ./ (1 + explogitpup);
end
