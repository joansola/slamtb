function [eu,EUhm] = hmg2euc(hm)

% HMG2EUC Homogeneous to Euclidean point transform.
%

s = size(hm,1);
n = size(hm,2);

eu = hm(1:s-1,:)./repmat(hm(s,:),s-1,1);

if nargout > 1 % Jacobians
    if n == 1
        EUhm = [1/hm(s)*eye(s-1) -eu/hm(s)]; % this takes any dimension
    else
        error('Jacobians not computed for multiple points in HM')
    end
end


return
