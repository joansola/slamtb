function [hm,HMrt] = rt2hmgLin(rt)

% RT2HMGLIN  Rho-theta to homogeneous line conversion.
%   RT2HMGLIN(RT) transforms the line RT=[rho;theta] into a homogeneous
%   line [a;b;c]. A homogeneous line is such that ax+by+c = 0 for any point
%   [x;y] of the line. For homogeneous points [x;y;t] we have ax+by+ct = 0.
%
%   [hm, HM_rt] = RT2HMGLIN(...) returns the Jacobian matrix.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

rho   = rt(1);
theta = rt(2);

a = cos(theta);
b = sin(theta);
c = -rho;

hm = [a;b;c];

if nargout > 1

    HMrt = [...
        [  0, -b]
        [  0,  a]
        [ -1,  0]];

end

return


%%

syms rho theta real

rt = [rho;theta];

[hm,HMrt] = rt2hmgLin(rt)

HMrt - jacobian(hm,rt)










