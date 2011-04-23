function [hf,HF_f,HF_h] = toFrameHmg(f,h)

% TOFRAMEHMG  To-frame transformation for homogeneous coordinates
%   P = TOFRAMEHMG(F,PF) transforms homogeneous point P from the global
%   frame to local frame F.
%
%   [p,Pf,Ppf] = ... returns the Jacobians wrt F and PF.

%   Copyright 2008-2011 Joan Sola @ LAAS-CNRS.



iF = inv(homogeneous(f));
[t,q] = splitFrame(f) ;

hf = iF*h;

if nargout > 1
    
    [x,y,z] = split(t);
    [a,b,c,d] = split(q);
    [hx,hy,hz,ht] = split(h);
    
    HF_f = [...
[ -(ht*(a^2 + b^2 - c^2 - d^2))/(a^2 + b^2 + c^2 + d^2)^2,           -(2*ht*(a*d + b*c))/(a^2 + b^2 + c^2 + d^2)^2,            (2*ht*(a*c - b*d))/(a^2 + b^2 + c^2 + d^2)^2, -(c*(b^2*(2*hz - 2*ht*z) + 2*d^2*hz - 2*d^2*ht*z) + a*(b^2*(2*hx - 2*ht*x) - c^2*(6*hx - 6*ht*x) - 6*d^2*hx + b*(8*d*hz - 8*d*ht*z) + 6*d^2*ht*x + b*c*(8*hy - 8*ht*y)) - b^2*(2*d*hy - 2*d*ht*y) - c^2*(2*d*hy - 2*d*ht*y) - a^2*(c*(6*hz - 6*ht*z) - 6*d*hy + 6*d*ht*y) + a^3*(2*hx - 2*ht*x) + c^3*(2*hz - 2*ht*z) - 2*d^3*hy + 2*d^3*ht*y)/(a^2 + b^2 + c^2 + d^2)^3, (c^2*(6*b*hx + 2*d*hz - 6*b*ht*x - 2*d*ht*z) - c*(6*b^2*hy - 2*d^2*hy - 6*b^2*ht*y + 2*d^2*ht*y) + a^2*(c*(2*hy - 2*ht*y) - 2*b*hx + 2*d*hz + 2*b*ht*x - 2*d*ht*z) - 2*b^3*hx + c^3*(2*hy - 2*ht*y) + 2*d^3*hz + a*(c*(8*b*hz - 8*b*ht*z) - 8*b*d*hy + 8*b*d*ht*y) + 2*b^3*ht*x - 2*d^3*ht*z + 6*b*d^2*hx - 6*b^2*d*hz - 6*b*d^2*ht*x + 6*b^2*d*ht*z)/(a^2 + b^2 + c^2 + d^2)^3,      -(a*(d^2*(2*hz - 2*ht*z) - 6*c^2*hz + d*(8*c*hy - 8*c*ht*y) + 6*c^2*ht*z) + a^2*(6*c*hx - 6*c*ht*x) - d^2*(2*c*hx - 2*c*ht*x) + b^2*(a*(2*hz - 2*ht*z) + 6*c*hx - 6*c*ht*x) - b^3*(2*hy - 2*ht*y) + a^3*(2*hz - 2*ht*z) - 2*c^3*hx - b*(a^2*(2*hy - 2*ht*y) - 6*c^2*hy + d^2*(2*hy - 2*ht*y) - d*(8*c*hz - 8*c*ht*z) + 6*c^2*ht*y) + 2*c^3*ht*x)/(a^2 + b^2 + c^2 + d^2)^3,        (a*(c^2*(2*hy - 2*ht*y) - 6*d^2*hy + c*(8*d*hz - 8*d*ht*z) + 6*d^2*ht*y) - a^2*(6*d*hx - 6*d*ht*x) + c^2*(2*d*hx - 2*d*ht*x) + b^2*(a*(2*hy - 2*ht*y) - 6*d*hx + 6*d*ht*x) + a^3*(2*hy - 2*ht*y) + b^3*(2*hz - 2*ht*z) + 2*d^3*hx + b*(a^2*(2*hz - 2*ht*z) + c^2*(2*hz - 2*ht*z) - 6*d^2*hz - c*(8*d*hy - 8*d*ht*y) + 6*d^2*ht*z) - 2*d^3*ht*x)/(a^2 + b^2 + c^2 + d^2)^3]
[            (2*ht*(a*d - b*c))/(a^2 + b^2 + c^2 + d^2)^2, -(ht*(a^2 - b^2 + c^2 - d^2))/(a^2 + b^2 + c^2 + d^2)^2,           -(2*ht*(a*b + c*d))/(a^2 + b^2 + c^2 + d^2)^2, -(a*(c^2*(2*hy - 2*ht*y) - b^2*(6*hy - 6*ht*y) - 6*d^2*hy + c*(8*d*hz - 8*d*ht*z) + 6*d^2*ht*y + b*c*(8*hx - 8*ht*x)) - b*(c^2*(2*hz - 2*ht*z) + 2*d^2*hz - 2*d^2*ht*z) + b^2*(2*d*hx - 2*d*ht*x) + c^2*(2*d*hx - 2*d*ht*x) + a^2*(b*(6*hz - 6*ht*z) - 6*d*hx + 6*d*ht*x) + a^3*(2*hy - 2*ht*y) - b^3*(2*hz - 2*ht*z) + 2*d^3*hx - 2*d^3*ht*x)/(a^2 + b^2 + c^2 + d^2)^3,         (a*(2*c^2*hz + d^2*(2*hz - 2*ht*z) - 2*c^2*ht*z) - b*(a^2*(6*hy - 6*ht*y) + 6*c^2*hy - d^2*(2*hy - 2*ht*y) + d*(8*c*hz - 8*c*ht*z) - 6*c^2*ht*y - a*d*(8*hx - 8*ht*x)) + a^2*(2*c*hx - 2*c*ht*x) + d^2*(2*c*hx - 2*c*ht*x) - b^2*(a*(6*hz - 6*ht*z) + 6*c*hx - 6*c*ht*x) + b^3*(2*hy - 2*ht*y) + a^3*(2*hz - 2*ht*z) + 2*c^3*hx - 2*c^3*ht*x)/(a^2 + b^2 + c^2 + d^2)^3, (b^2*(6*c*hy + 2*d*hz - 6*c*ht*y - 2*d*ht*z) - b*(6*c^2*hx - 2*d^2*hx - 6*c^2*ht*x + 2*d^2*ht*x) + a^2*(b*(2*hx - 2*ht*x) - 2*c*hy + 2*d*hz + 2*c*ht*y - 2*d*ht*z) + b^3*(2*hx - 2*ht*x) - 2*c^3*hy + 2*d^3*hz - a*(b*(8*c*hz - 8*c*ht*z) - 8*c*d*hx + 8*c*d*ht*x) + 2*c^3*ht*y - 2*d^3*ht*z + 6*c*d^2*hy - 6*c^2*d*hz - 6*c*d^2*ht*y + 6*c^2*d*ht*z)/(a^2 + b^2 + c^2 + d^2)^3, -(a*(2*c^2*hx - 6*d^2*hx - 2*c^2*ht*x + 6*d^2*ht*x) - a^2*(2*c*hz - 6*d*hy - 2*c*ht*z + 6*d*ht*y) + b^2*(a*(2*hx - 2*ht*x) - 2*c*hz - 2*d*hy + 2*c*ht*z + 2*d*ht*y) + a^3*(2*hx - 2*ht*x) - 2*c^3*hz - 2*d^3*hy + b*(a*(8*d*hz - 8*d*ht*z) + 8*c*d*hx - 8*c*d*ht*x) + 2*c^3*ht*z + 2*d^3*ht*y + 6*c^2*d*hy + 6*c*d^2*hz - 6*c^2*d*ht*y - 6*c*d^2*ht*z)/(a^2 + b^2 + c^2 + d^2)^3]
[           -(2*ht*(a*c + b*d))/(a^2 + b^2 + c^2 + d^2)^2,            (2*ht*(a*b - c*d))/(a^2 + b^2 + c^2 + d^2)^2, -(ht*(a^2 - b^2 - c^2 + d^2))/(a^2 + b^2 + c^2 + d^2)^2, -(b*(2*c^2*hy + d^2*(2*hy - 2*ht*y) - 2*c^2*ht*y) + a*(d^2*(2*hz - 2*ht*z) - 6*c^2*hz - b^2*(6*hz - 6*ht*z) + d*(8*c*hy - 8*c*ht*y) + 6*c^2*ht*z + b*d*(8*hx - 8*ht*x)) - b^2*(2*c*hx - 2*c*ht*x) - d^2*(2*c*hx - 2*c*ht*x) - a^2*(b*(6*hy - 6*ht*y) - 6*c*hx + 6*c*ht*x) + b^3*(2*hy - 2*ht*y) + a^3*(2*hz - 2*ht*z) - 2*c^3*hx + 2*c^3*ht*x)/(a^2 + b^2 + c^2 + d^2)^3,         (a^2*(2*d*hx - 2*d*ht*x) - b*(a^2*(6*hz - 6*ht*z) - c^2*(2*hz - 2*ht*z) + 6*d^2*hz + c*(8*d*hy - 8*d*ht*y) - 6*d^2*ht*z + a*c*(8*hx - 8*ht*x)) - a*(c^2*(2*hy - 2*ht*y) + 2*d^2*hy - 2*d^2*ht*y) + c^2*(2*d*hx - 2*d*ht*x) + b^2*(a*(6*hy - 6*ht*y) - 6*d*hx + 6*d*ht*x) - a^3*(2*hy - 2*ht*y) + b^3*(2*hz - 2*ht*z) + 2*d^3*hx - 2*d^3*ht*x)/(a^2 + b^2 + c^2 + d^2)^3, (b^2*(a*(2*hx - 2*ht*x) + 2*c*hz + 2*d*hy - 2*c*ht*z - 2*d*ht*y) - a*(6*c^2*hx - 2*d^2*hx - 6*c^2*ht*x + 2*d^2*ht*x) - a^2*(6*c*hz - 2*d*hy - 6*c*ht*z + 2*d*ht*y) + a^3*(2*hx - 2*ht*x) + 2*c^3*hz + 2*d^3*hy + b*(a*(8*c*hy - 8*c*ht*y) - 8*c*d*hx + 8*c*d*ht*x) - 2*c^3*ht*z - 2*d^3*ht*y - 6*c^2*d*hy - 6*c*d^2*hz + 6*c^2*d*ht*y + 6*c*d^2*ht*z)/(a^2 + b^2 + c^2 + d^2)^3,  (b^2*(2*c*hy + 6*d*hz - 2*c*ht*y - 6*d*ht*z) + b*(2*c^2*hx - 6*d^2*hx - 2*c^2*ht*x + 6*d^2*ht*x) + a^2*(b*(2*hx - 2*ht*x) + 2*c*hy - 2*d*hz - 2*c*ht*y + 2*d*ht*z) + b^3*(2*hx - 2*ht*x) + 2*c^3*hy - 2*d^3*hz + a*(b*(8*d*hy - 8*d*ht*y) - 8*c*d*hx + 8*c*d*ht*x) - 2*c^3*ht*y + 2*d^3*ht*z - 6*c*d^2*hy + 6*c^2*d*hz + 6*c*d^2*ht*y - 6*c^2*d*ht*z)/(a^2 + b^2 + c^2 + d^2)^3]
[                                                       0,                                                       0,                                                       0,                                                                                                                                                                                                                                                                                                                                                                        0,                                                                                                                                                                                                                                                                                                                                                                               0,                                                                                                                                                                                                                                                                                                                                                                               0,                                                                                                                                                                                                                                                                                                                                                                                0]];

    HF_h = iF;
    
end

end

%%
function f()
%%
syms x y z a b c d hx hy hz ht real
f.x=[x;y;z;a;b;c;d];
f=updateFrame(f);
h = [hx;hy;hz;ht];
hf = toFrameHmg(f,h)
HF_f = simplify(jacobian(hf,f.x))
HF_h = simplify(jacobian(hf,h))
[hf,HF_f,HF_h] = toFrameHmg(f,h);
simplify(HF_f - jacobian(hf,f.x))
simplify(HF_h - jacobian(hf,h))

%%
end




% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright 2007,2008,2009
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

