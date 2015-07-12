function [ahm,AHM_f,AHM_ahmf] = fromFrameAhm(F,ahmf)

% FROMFRAMEAHM  Transforms AHM from local frame to global frame.
%   AHM = FROMFRAMEAHM(F,AHMF) transforms the Inverse Depth point IF from the
%   local frame F to the global frame. The frame F can be specified either
%   with a 7-vector F=[T;Q], where T is the translation vector and Q the
%   orientation quaternion, of via a structure containing at least the
%   fields F.t, F.q, F.R and F.Rt (translation, quaternion, rotation matrix
%   and its transpose).
%
%   [AHM,AHM_f,AHM_if] = FROMFRAMEAHM(...) returns the Jacobians wrt F and AHMF.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


xf  = ahmf(1:3,:);
mf  = ahmf(4:6,:);
sf  = ahmf(7,:);

[t,q,R] = splitFrame(F);

if nargout == 1

    x  = fromFrame(F,xf);
    m  = R*mf;

    ahm  = [x;m;sf];

else

    if size(ahmf,2) > 1
        error('Jacobians not available for multiple ahms')
    else

        [x, X_f, X_xf] = fromFrame(F,xf);
        [m,M_q,M_mf]   = Rp(q,mf);

        ahm    = [x;m;sf];

        AHM_f = [...
            X_f
            zeros(3,3) M_q
            zeros(1,7)];

        AHM_ahmf = [...
            X_xf          zeros(3,4)
            zeros(3,3) M_mf zeros(3,1)
            zeros(1,6)           1];

    end
end

return

%% jac

syms x y z a b c d X Y Z U V W R real
F   = [x;y;z;a;b;c;d];
ahmf = [X;Y;Z;U;V;W;R];

[ahm,AHM_f,AHM_ahmf] = fromFrameAhm(F,ahmf);

simplify(AHM_f  - jacobian(ahm,F))
simplify(AHM_ahmf - jacobian(ahm,ahmf))



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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

