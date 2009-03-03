function Ray = balWeight(Ray)

% BALWEIGHT  Balance ray weights
%   RAY = BALWEIGHT(RAY) re-balances the weights of ray RAY
%   in order to avoid degeneracy. Balance is performed
%   in a geometric base, ie for every weight W = RAY.w:
%
%     W = W^(1-gamma)
%
%   where:
%     gamma = RAY.gamma  is the vanishing factor
%
%   See also RAYLIKELIHOOD, NORMWEIGHT, PRUNEPOINTS, FISUPDATE

gamma = Ray.gamma;

wi = Ray.w(1:Ray.n);

wo = wi.^(1-gamma); % rebalance weights

Ray.w(1:Ray.n) = wo;
