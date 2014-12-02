function [hf,HF_f,HF_h] = toFrameHmg(F,h)

% TOFRAMEHMG  To-frame transformation for homogeneous coordinates
%   P = TOFRAMEHMG(F,PF) transforms homogeneous point P from the global
%   frame to local frame F.
%
%   [p,Pf,Ppf] = ... returns the Jacobians wrt F and PF.

%   Copyright 2008-2011 Joan Sola @ LAAS-CNRS.



[t,q,R] = splitFrame(F) ;
iF = [R' -R'*t ; 0 0 0 1];

hf = iF*h;

if nargout > 1
    
    [x,y,z] = split(t);
    [a,b,c,d] = split(q);
    [hx,hy,hz,ht] = split(h);
    
    HF_f = [...
[ -ht*(a^2 + b^2 - c^2 - d^2),         (-2)*ht*(a*d + b*c),            2*ht*(a*c - b*d), 2*a*hx - 2*c*hz + 2*d*hy - 2*ht*(a*x - c*z + d*y), 2*b*hx + 2*c*hy + 2*d*hz - 2*ht*(b*x + c*y + d*z), 2*b*hy - 2*a*hz - 2*c*hx + 2*ht*(a*z - b*y + c*x), 2*a*hy + 2*b*hz - 2*d*hx - 2*ht*(a*y + b*z - d*x)]
[            2*ht*(a*d - b*c), -ht*(a^2 - b^2 + c^2 - d^2),         (-2)*ht*(a*b + c*d), 2*a*hy + 2*b*hz - 2*d*hx - 2*ht*(a*y + b*z - d*x), 2*a*hz - 2*b*hy + 2*c*hx - 2*ht*(a*z - b*y + c*x), 2*b*hx + 2*c*hy + 2*d*hz - 2*ht*(b*x + c*y + d*z), 2*c*hz - 2*a*hx - 2*d*hy + 2*ht*(a*x - c*z + d*y)]
[         (-2)*ht*(a*c + b*d),            2*ht*(a*b - c*d), -ht*(a^2 - b^2 - c^2 + d^2), 2*a*hz - 2*b*hy + 2*c*hx - 2*ht*(a*z - b*y + c*x), 2*d*hx - 2*b*hz - 2*a*hy + 2*ht*(a*y + b*z - d*x), 2*a*hx - 2*c*hz + 2*d*hy - 2*ht*(a*x - c*z + d*y), 2*b*hx + 2*c*hy + 2*d*hz - 2*ht*(b*x + c*y + d*z)]
[                           0,                           0,                           0,                                                 0,                                                 0,                                                 0,                                                 0]];

    HF_h = iF;
    
end

end

%%
function f()
%%
syms x y z a b c d hx hy hz ht real
F.x=[x;y;z;a;b;c;d];
F=updateFrame(F);
h = [hx;hy;hz;ht];
hf = toFrameHmg(F,h)
HF_f = simplify(jacobian(hf,F.x))
HF_h = simplify(jacobian(hf,h))
[hf,HF_f,HF_h] = toFrameHmg(F,h);
simplify(HF_f - jacobian(hf,F.x))
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

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

