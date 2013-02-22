function [p,Pup,Ps] = persp_retro(up,s)

% PERSP_RETRO  Retroproject pixel into 3D space.
%   P = PERSP_RETRO(UP,S) retro-projects the point UP of the image
%   plane into the point P at depth S in 3D space using a
%   normalized camera.
%
%   See also INVPINHOLE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



p = [s.*up(1,:) ; s.*up(2,:) ; s.*ones(1,size(up,2))];

if nargout > 1
    Pup = s*eye(3,2);
    Ps  = [up;1];
end

return

%% jac

syms u v s real
up = [u;v];

[p,Pup,Ps] = retro(up,s);

Pup - jacobian(p,up)
Ps - jacobian(p,s)








