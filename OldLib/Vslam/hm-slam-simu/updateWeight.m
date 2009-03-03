function Ray = updateWeight(Ray)

% UPDATEWEIGHT  Update ray weights
%   RAY = UPDATEWEIGHT(RAY) updates ray weights with ray
%   likelihoods and normalizes.

Ray.w = Ray.w.*Ray.li;
Ray = normWeight(Ray);