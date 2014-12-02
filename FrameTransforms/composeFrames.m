function [H, H_f, H_g] = composeFrames(F,G)

% COMPOSEFRAMES  Compose two 3D frames.
%   H = COMPOSEFRAMES(F,G) composes frames F and G, where frame G is
%   specified in frame F, to get a single frame transform H. Frames are
%   structures with at least the following fields:
%       .t  translation vector
%       .q  orientation quaternion
%
%   The resulting frame H, however, contains the full frame structure.
%
%   [H, H_f, H_g] = COMPOSEFRAMES(...) returns the Jacobians of H.x wrt F.x
%   and G.x.
%
%   See also FRAME, SPLITFRAME, QUATERNION.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout == 1
    
    H.t = fromFrame(F,G.t);
    H.q = qProd(F.q,G.q);
    H.x = [H.t;H.q];
    H   = updateFrame(H);
    
else
    
    [H.t, T_f, T_tg]  = fromFrame(F,G.t);
    [H.q, Q_qf, Q_qg] = qProd(F.q,G.q);
    
    H.x = [H.t;H.q];
    H   = updateFrame(H);
    
%     H_f = zeros(7);
%     H_g = zeros(7);
    
    H_f(1:3,:)   = T_f;
    H_f(4:7,4:7) = Q_qf;
    H_g(1:3,1:3) = T_tg;
    H_g(4:7,4:7) = Q_qg;
    
end

%%
function f()
%%
syms x y z a b c d X Y Z A B C D real
F.x = [x y z a b c d]';
G.x = [X Y Z A B C D]';
F = updateFrame(F);
G = updateFrame(G);
[H, H_f, H_g] = composeFrames(F,G);
simplify(H_f-jacobian(H.x,F.x))
simplify(H_g-jacobian(H.x,G.x))


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

