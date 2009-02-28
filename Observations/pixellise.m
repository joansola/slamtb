function [pix,PIXu,PIXk] = pixellise(u,k)

% PIXELLISE  Metric to pixellic conversion
%   PIXELLISE(U,K) maps the projected point U to the pixels matrix defined
%   by the camera calibration parameters K = [u0 v0 au av]. It works with
%   sets of pixels if they are defined by a matrix U = [U1 U2 ... Un] ,
%   where Ui = [ui;vi]
%
%   [p,Pu,Pk] = PIXELLISE(...) returns the jacobians wrt U and K. This
%   only works for single pixels U=[u;v], not for sets of pixels.

u0 = k(1);
v0 = k(2);
au = k(3);
av = k(4);

pix = [...
    u0 + au*u(1,:)
    v0 + av*u(2,:)];

if nargout > 1 % jacobians
    PIXu = [...
        [ au,  0]
        [  0, av]];
    PIXk = [...
        [  1,  0, u(1),    0]
        [  0,  1,    0, u(2)]];
end

return

%% build jacobians

syms u1 u2 u0 v0 au av real

u = [u1;u2];
k = [u0 v0 au av]';

pix = pixellise(u,k);

PIXu = jacobian(pix,u)
PIXk = jacobian(pix,k)

