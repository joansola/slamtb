function [p, P_r, P_s, P_k, P_c, P_v] = retroProjEucPntFromPhdOnRob(Rf, Sf, k, c, v)

% RETROPROJEUCPNTFROMPHDONROB Retro-proj Euc. pnt. from Pinhole-depth in Rob
%   [p, P_r, P_s, P_k, P_c, P_v] = RETROPROJEUCPNTFROMPHDONROB(Rf, Sf, k, c, v)
%   retro-projects the pixel+depth measurement v from a pinhole+depth
%   camera installed on a robot. The robot frame is Rf, and the camera
%   frame in the robot is Sf. k is the intrinsic vector of the subjacent
%   pinhole model, and c the distortion correction vector.
%
%   See also INVPINHOLEDEPTH, PROJEUCPNTINTOPHDONROB.

%   Copyright 2015-     Joan Sola @ IRI-UPC-CSIC.


if nargout == 1
    
    p = fromFrame(composeFrames(Rf, Sf),  invPinHoleDepth(v, k, c));
    
else
    
    [RSf, RS_r, RS_s] = composeFrames(Rf, Sf);
    
    [prs, PRS_v, PRS_k, PRS_c] = invPinHoleDepth(v, k, c);
    
    [p, P_rs, P_prs] = fromFrame(RSf, prs);
    
    P_r = P_rs * RS_r;
    P_s = P_rs * RS_s;
    P_k = P_prs * PRS_k;
    P_c = P_prs * PRS_c;
    P_v = P_prs * PRS_v;
    
end

return

%%

syms rx ry rz ra rb rc rd sx sy sz sa sb sc sd u0 v0 au av x y z real
Rf.x = [rx ry rz ra rb rc rd]';
Rf = updateFrame(Rf);
Sf.x = [sx sy sz sa sb sc sd]';
Sf = updateFrame(Sf);
k = [u0 v0 au av]';
l = [x y z]';

[u, U_r, U_s, U_k, U_d, U_l] = ...
    projEucPntIntoPhdOnRob(Rf, Sf, k, [], l);

[p, P_r, P_s, P_k, P_c, P_u] = retroProjEucPntFromPhdOnRob(Rf, Sf, k, [], u);


% simplify(U_r - jacobian(u,Rf.x)) % Too slow



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

