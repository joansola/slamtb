function [rts,RTS_ees] = ees2rts(ees)

% EES2RTS  2 stereo segments to 2 rho-theta lines transform.
%   EES2RTS(EES) returns a 4-vector with the 2 rho-theta representations
%   corresponding to the two segments in EES=[e1_l e2_l e1_r e2_r].
%
%   [rts,RTS_ees] = ... returns the 4x8 Jacobian wrt EES.
%
%   See also POINTS2RT, UVDS2RTS.

% (c) 2008 Joan Sola @ LAAS-CNRS.

el1 = ees(1:2);
el2 = ees(3:4);
er1 = ees(5:6);
er2 = ees(7:8);

if nargout == 1
    
    rtl = points2rt(el1,el2);
    rtr = points2rt(er1,er2);

    rts = [rtl;rtr];

else

    [rtl,RTL_el1,RTL_el2] = points2rt(el1,el2);
    [rtr,RTR_er1,RTR_er2] = points2rt(er1,er2);

    rts = [rtl;rtr];

    Z22 = zeros(2);
    RTS_ees = [RTL_el1 RTL_el2 Z22 Z22
        Z22 Z22 RTR_er1 RTR_er2];

end

return

%%
syms e1 e2 e3 e4 e5 e6 e7 e8 real
ees = [e1 e2 e3 e4 e5 e6 e7 e8]';

[rts,RTS_ees] = ees2rts(ees);

simplify(RTS_ees - jacobian(rts,ees))

%%
ees = [1 2 -2 2 3 2 0 2]';
[rts,RTS_ees] = ees2rts(ees)