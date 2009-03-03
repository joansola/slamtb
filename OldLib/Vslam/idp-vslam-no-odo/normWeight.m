function Ray = normWeight(Ray)

% NORMWEIGHT  Normalize ray weights
%   Ray = NORMWEIGHT(Ray) normalizes weights of active
%   ray points so that  sum(Ray.w) = 1

Ray.w(1:Ray.n) = Ray.w(1:Ray.n)/sum(Ray.w(1:Ray.n));
