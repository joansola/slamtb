function [pix,PIXu,PIXcal] = pixellise(u,cal)

% PIXELLISE  Metric to pixellic conversion
%   PIXELLISE(U,CAL) maps the projected point U to the pixel matrix defined
%   by the camera calibration parameters CAL = [u0 v0 au av]. It works with
%   sets of pixels if they are defined by U = [U1 U2 ... Un] ,
%   where Ui = [ui;vi]
%
%   [p,Pu,Pcal] = PIXELLISE(...) returns the jacobians wrt U and CAL. It
%   only works for single pixels U=[u;v], not for sets of pixels.

u0 = cal(1);
v0 = cal(2);
au = cal(3);
av = cal(4);

pix = [...
    u0 + au*u(1,:)
    v0 + av*u(2,:)];

if nargout > 1 % jacobians
    PIXu = [...
        [ au,  0]
        [  0, av]];
    PIXcal = [...
        [  1,  0, u(1),    0]
        [  0,  1,    0, u(2)]];
end

return

%% build jacobians

syms u1 u2 u0 v0 au av real

u = [u1;u2];
cal = [u0 v0 au av]';

pix = pixellise(u,cal);

PIXu = jacobian(pix,u)
PIXcal = jacobian(pix,cal)

