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

