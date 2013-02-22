function [eu,EUhm] = hmg2euc(hm)

% HMG2EUC Homogeneous to Euclidean point transform.
%   UMG2EUC(HM) is the Euclidean point corresponding to the homogeneous
%   point HM.
%
%   [e, E_hm] = HMG2EUC(HM) returns the Jacobian of the transformation.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


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









