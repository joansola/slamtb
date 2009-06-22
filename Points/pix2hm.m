function [hm,HMpix] = pix2hm(pix)

% TODO
%
%

hm = [pix;1];

if nargout > 1 % Jac -- OK
    
    HMpix = [eye(numel(pix));zeros(1,numel(pix))];

end

return
