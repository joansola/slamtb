function [p_F,Tf,Tp] = toFrame(F,p_W)

% TOFRAME  Express in local frame a set of points from global frame.
%   TOFRAME(F,P_W)  takes the W-referenced points matrix P_W and
%   returns it in frame F.
%   P_W is a points matrix defined as
%     P_W = [P_1 P_2 ... P_N], where
%     P_i = [x_i;y_i;z_i]
%
%   F is either a structure containing at least:
%     t : frame position
%     q : frame orientation quaternion
%     Rt: transposed rotation matrix
%     Pc: Conjugated Pi matrix
%
%   or a 7-vector F = [t;q].
%
%   [p_F,Tf,Tp] = ... returns the Jacobians of toFrame:
%     Tf: wrt the frame [t;q]
%     Tp: wrt the point P_W
%   Note that this is only available for single points.
%
%   See also FRAME, FROMFRAME, Q2PI, PI2PC, QUATERNION, UPDATEFRAME, SPLITFRAME.

%   [1] Joan Sola, "Towards visual localization, mapping and moving objects
%   tracking by a moible robot," PhD dissertation, pages 181-183, Institut
%   National Politechnique de Toulouse, 2007.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

s = size(p_W,2); % number of points in input matrix

[t,q,R,Rt] = splitFrame(F);

if s==1 % one point

    p_F = Rt*p_W - Rt*t;
   
    if nargout > 1 % Jacobians. See [1] for details.
        sc  = 2*q2Pi(q2qc(q))*(p_W-t);   % Conjugated s

        Tt  = -Rt;
        Tq  = [...
            sc(2)  sc(1) -sc(4)  sc(3)
            sc(3)  sc(4)  sc(1) -sc(2)
            sc(4) -sc(3)  sc(2)  sc(1)];
        Tp  = Rt;
        Tf  = [Tt Tq];
    end

else % multiple points
    p      = p_W;
    p(1,:) = p(1,:) - t(1);
    p(2,:) = p(2,:) - t(2);
    p(3,:) = p(3,:) - t(3);  % p = p_W - repmat(t,1,s);
    p_F = Rt*p;
    if nargout > 1
        error('Can''t give Jacobians for multiple points');
    end
end

return

%% jacobian test

syms x y z a b c d px py pz real
F.x = [x;y;z;a;b;c;d];
p_W = [px;py;pz];
F   = updateFrame(F);

[p_F,Tf,Tp] = toFrame(F,p_W);

simplify(Tf - jacobian(p_F,F.x))
simplify(Tp - jacobian(p_F,p_W))



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

