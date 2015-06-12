function [i_F,IF_f,IF_i] = toFrameIdp(F,i)

% TOFRAMEIDP  Transforms IDP from global frame to local frame.
%   IF = TOFRAMEIDP(F,I) transforms the Inverse Depth point I from the
%   global frame to a local frame F. The frame F can be specified either
%   with a 7/vector F=[T;Q],where T is the translation vector and Q the
%   orientation quaternion, of via a structure containing at least the
%   fields F.t, F.q, F.R and F.Rt (translation, quaternion, rotation matrix
%   and its transpose).
%
%   [IF,IF_f,IF_i] = TOFRAMEIDP(...) returns the Jacobians wrt F and I.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

x  = i(1:3,:);
py = i(4:5,:);
s  = i(6,:);

[t,q,R,Rt] = splitFrame(F);

if nargout == 1

    x_F  = toFrame(F,x);
    m    = py2vec(py);
    m_F  = Rt*m;
    py_F = vec2py(m_F); % FIXME: vec2py does not admit multiple vecs.

    i_F  = [x_F;py_F;s];

else

    if size(i,2) > 1
        error('Jacobians not available for multiple idps')
    else

        [xf, XF_f, XF_x] = toFrame(F,x);
        [m, M_py]        = py2vec(py);
        [mf,MF_q,MF_m]   = Rtp(q,m);
        [pyf,PYF_mf]     = vec2py(mf);

        i_F    = [xf;pyf;s];

        PYF_py = PYF_mf*MF_m*M_py;

        IF_f = [...
            XF_f
            zeros(2,3) PYF_mf*MF_q
            zeros(1,7)];

        IF_i = [...
            XF_x zeros(3,3)
            zeros(2,3) PYF_py zeros(2,1)
            zeros(1,5) 1];

    end
end

return

%% jac

syms x y z a b c d X Y Z A B R real
F = [x;y;z;a;b;c;d];
i = [X;Y;Z;A;B;R];

[i_F,IF_f,IF_i] = toFrameIdp(F,i);

simplify(IF_f - jacobian(i_F,F))
simplify(IF_i - jacobian(i_F,i))

%% multiple idps

i = randn(6,2);
F = [randn(3,1);normvec(randn(4,1))];

i_F = toFrameIdp(F,i)



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

