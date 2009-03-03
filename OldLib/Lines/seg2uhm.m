function [uhm,UHM_s] = seg2uhm(s)

% SEG2UHM Segment to unit normalized homogeneous line.
%   SEG2UHM(S) returns the unit normalized homogeneous line corresponding
%   to the segment S.
%
%   [uhm,UHM_s] = SEG2UHM(S) returns the Jacobian wrt S.
%
%   See also SEG2HM, HM2UHM.

if nargout == 1
    uhm = hm2uhm(seg2hm(s));
else
    [hm,HM_s] = seg2hm(s);
    [uhm,UHM_hm] = hm2uhm(hm); % 0: jacobian follows definition; 1: just norm
    UHM_s = UHM_hm*HM_s;
end

return

%% jac
syms e11 e12 e21 e22 real
s = [e11 e12 e21 e22]';
[uhm,UHM_s] = seg2uhm(s);

simplify(UHM_s - jacobian(uhm,s))
