function Ray = balWeight(Ray)

% BALWEIGHT  Balance ray weights
%   RAY = BALWEIGHT(RAY) re-balances the weights of ray RAY
%   in order to avoid degeneracy. Balance is performed
%   in a geometric base, ie for every weight W = RAY.w:
%
%     W = W^(1-gamma) / n^(gamma)
%   
%   where:
%     gamma = RAY.gamma  is the vanishing factor
%     n     = RAY.n      is the number of terms of the ray
%
%   See also RAYLIKELIHOOD, NORMWEIGHT, PRUNEPOINTS, FISUPDATE

gamma = Ray.gamma;

wi = Ray.w(1:Ray.n);

% figure(4)
% plot(wi,'r')
% axis([1 3 0 1])
% hold on

wo = wi.^(1-gamma); % rebalance weights
wo = wo/sum(wo);

% plot(wo,'b')
% hold off
% drawnow

Ray.w(1:Ray.n) = wo;
