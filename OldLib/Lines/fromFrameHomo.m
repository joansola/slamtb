function [h,Hf,Hh] = fromFrameHomo(f,hf)

% FROMFRAMEHOMO  Fom-frame transformation for homogeneous coordinates
%   P = FROMFRAMEHOMO(F,PF) transforms homogeneous point PF from frame F to
%   the global frame.
%
%   [p,Pf,Ppf] = ... returns the Jacobians wrt F and PF.

F = homogeneous(f);

h = F*hf;

if nargout > 1

    [a,b,c,d] = split(f(4:7));
    [hx,hy,hz,ht] = split(hf);

    Ht = [...
        [ ht,  0,  0]
        [  0, ht,  0]
        [  0,  0, ht]
        [  0,  0,  0]];
    Hq = [...
        [  2*a*hx-2*d*hy+2*c*hz,  2*b*hx+2*c*hy+2*d*hz, -2*c*hx+2*b*hy+2*a*hz, -2*d*hx-2*a*hy+2*b*hz]
        [  2*d*hx+2*a*hy-2*b*hz,  2*c*hx-2*b*hy-2*a*hz,  2*b*hx+2*c*hy+2*d*hz,  2*a*hx-2*d*hy+2*c*hz]
        [ -2*c*hx+2*b*hy+2*a*hz,  2*d*hx+2*a*hy-2*b*hz, -2*a*hx+2*d*hy-2*c*hz,  2*b*hx+2*c*hy+2*d*hz]
        [                     0,                     0,                     0,                     0]];

    Hf = [Ht Hq];
    Hh = F;

end

return

%%
syms x y z a b c d real
syms hx hy hz ht real
t = [x;y;z];
q = [a;b;c;d];
f = [t;q];

hf = [hx;hy;hz;ht];

h = fromFrameHomo(f,hf);

Ht = jacobian(h,t)
Hq = jacobian(h,q)
Hh = jacobian(h,hf)

