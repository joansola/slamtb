function [hm,HMpix] = euc2hmg(pix)

% EUC2HMG Euclidean to Homogeneous transform.
% The scale factor is 1 for the return hmg point.
%

hm = [pix;1];

if nargout > 1 % Jac -- OK
    
    HMpix = [eye(numel(pix));zeros(1,numel(pix))];

end

return
