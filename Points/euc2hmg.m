function [hm,HMpix] = euc2hmg(pix)

% EUC2HMG Euclidean to Homogeneous point transform.
%   EUC2HMG(E) transforms the Euclidean point E onto homogeneous space by
%   appending 1 at the last coordinate.
%
%   [h,H_e] = EUC2HMG(E) returns the Jacobian of the transformation.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


hm = [pix;1];

if nargout > 1 % Jac -- OK
    
    HMpix = [eye(numel(pix));zeros(1,numel(pix))];

end

return









