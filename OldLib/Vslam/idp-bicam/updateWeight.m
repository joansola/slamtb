function Ray = updateWeight(Ray,prj)

% UPDATEWEIGHT  Update ray weights
%   RAY = UPDATEWEIGHT(RAY,PRJ) updates ray weights with ray
%   likelihoods of the current projection PRJ and normalizes.

Ray.w = Ray.w.*Ray.Prj(prj).li;
Ray = normWeight(Ray);