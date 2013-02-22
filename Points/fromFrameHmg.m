function [h,Hf,Hh] = fromFrameHmg(f,hf)

% FROMFRAMEHMG  Fom-frame transformation for homogeneous coordinates
%   P = FROMFRAMEHMG(F,PF) transforms homogeneous point PF from frame F to
%   the global frame.
%
%   [p,Pf,Ppf] = ... returns the Jacobians wrt F and PF.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



F = homogeneous(f)    ;
[t,q] = splitFrame(f) ;

h = F*hf;

if nargout > 1

    [a,b,c,d] = split(q);
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










