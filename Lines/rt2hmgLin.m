function [hm,HMrt] = rt2hmgLin(rt)

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

