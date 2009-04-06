function [uu,Up,Uc] = depixellise(pix,cal)

% DEPIXELLISE  Pixellic to metric conversion
%   DEPIXELLISE(PIX,CAL) returns the metric coordinates of an image pixel
%   PIX given camera intrinsic parameters CAL = [u0 v0 au av]'
%
%   [u,Up,Uc] = DEPIXELLISE(...) gives the jacobians wrt PIX and CAL.
%
%   See also INVPINHOLE.

u0 = cal(1);
v0 = cal(2);
au = cal(3);
av = cal(4);

u = pix(1,:);
v = pix(2,:);

uu = [(u-u0)/au
    (v-v0)/av];

if nargout > 1
    Up = [...
        [ 1/au,    0]
        [    0, 1/av]];
    Uc = [...
        [        -1/au,            0, (-u+u0)/au^2,            0]
        [            0,        -1/av,            0, (-v+v0)/av^2]];
end

return

%% jacobians test

syms u0 v0 au av u v real
pix = [u;v];
cal = [u0;v0;au;av];

[u,Up,Uc] = depixellise(pix,cal);

simplify(Up - jacobian(u,pix))
simplify(Uc - jacobian(u,cal))
