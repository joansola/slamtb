function [ep,EP_epj] = eposeJafar2epose(epj)

% EPOSEJAFAR2EPOSE  Transform pose from Jafar format to normal.
%   Jafar ose is [ x y z yaw pitch roll]
%   Normal pose is [x y z roll pitch yaw]
%   the Jacobian is given.

ep = epj([1 2 3 6 5 4]);

EP_epj = [...
    1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 1 0 0 0;
    0 0 0 0 0 1;
    0 0 0 0 1 0;
    0 0 0 1 0 0];



return

%%

syms x y z r p w real
epj = [x;y;z;w;p;r];

ep = eposeJafar2epose(epj)

jacobian(ep,epj)
