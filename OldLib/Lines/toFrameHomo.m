function [hf,HFf,HFh] = toFrameHomo(f,h)

% TOFRAMEHOMO  TO-frame transformation for homogeneous coordinates
%   PF = TOFRAMEHOMO(F,P) transforms homogeneous point P from the global
%   frame to the frame F.
%
%   [pf,PFf,PFp] = ... returns the Jacobians wrt F and P.

iF = invHomogeneous(f);

hf = iF*h;

if nargout > 1 % jacobians -- OK

    [x,y,z,a,b,c,d] = split(f);
    [hx,hy,hz,ht] = split(h);

    HFt = [...
        [ (-a^2-b^2+c^2+d^2)*ht,     (-2*b*c-2*a*d)*ht,     (-2*b*d+2*a*c)*ht]
        [     (-2*b*c+2*a*d)*ht, (-a^2+b^2-c^2+d^2)*ht,     (-2*c*d-2*a*b)*ht]
        [     (-2*b*d-2*a*c)*ht,     (-2*c*d+2*a*b)*ht, (-a^2+b^2+c^2-d^2)*ht]
        [                     0,                     0,                     0]];
    HFq = [...
        [ 2*a*hx+2*d*hy-2*c*hz+(-2*a*x-2*d*y+2*c*z)*ht, 2*b*hx+2*c*hy+2*d*hz+(-2*b*x-2*c*y-2*d*z)*ht, -2*c*hx+2*b*hy-2*a*hz+(2*c*x-2*b*y+2*a*z)*ht, -2*d*hx+2*a*hy+2*b*hz+(2*d*x-2*a*y-2*b*z)*ht]
        [ -2*d*hx+2*a*hy+2*b*hz+(2*d*x-2*a*y-2*b*z)*ht, 2*c*hx-2*b*hy+2*a*hz+(-2*c*x+2*b*y-2*a*z)*ht, 2*b*hx+2*c*hy+2*d*hz+(-2*b*x-2*c*y-2*d*z)*ht, -2*a*hx-2*d*hy+2*c*hz+(2*a*x+2*d*y-2*c*z)*ht]
        [ 2*c*hx-2*b*hy+2*a*hz+(-2*c*x+2*b*y-2*a*z)*ht, 2*d*hx-2*a*hy-2*b*hz+(-2*d*x+2*a*y+2*b*z)*ht, 2*a*hx+2*d*hy-2*c*hz+(-2*a*x-2*d*y+2*c*z)*ht, 2*b*hx+2*c*hy+2*d*hz+(-2*b*x-2*c*y-2*d*z)*ht]
        [                                            0,                                            0,                                            0,                                            0]];
    HFf = [HFt HFq];

    HFh = iF;

end

return

%%
syms x y z a b c d real
syms hx hy hz ht real
t = [x;y;z];
q = [a;b;c;d];
f = [t;q];

h = [hx;hy;hz;ht];

[hf,HFf,HFh] = toFrameHomo(f,h);

HFf - simple(jacobian(hf,f))
HFh - jacobian(hf,h)

