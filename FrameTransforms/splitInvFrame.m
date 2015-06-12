function [it,Rt,Pc] = splitInvFrame(F)

% SPLITINVFRAME  Split inverse frame information.
%   [iT,Rt] = SPLITINVFRAME(F), for a frame F, returns the inverse
%   translation vector iT and the transposed rotation matrix Rt. The frame
%   F can be either a 7-vector F=[T;Q] or a structure containing, at least,
%   the fields F.it and F.Rt.
%
%   [iT,Rt,Pc] = SPLITINVFRAME(F) returns in addition the conjugated Pi
%   matrix Pc. See toFrame for explanations on matrices Pi and Pc. If F is
%   a frame structure, it needs to contain the field F.Pc.
%
%   See also FRAME, SPLITFRAME, UPDATEFRAME, TOFRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if isa(F,'struct')
    it = F.it;
    Rt = F.Rt;

    if nargout > 2
        Pc = F.Pc;
    end
    
else % F is a 7-vector
    Rt = q2R(F(4:7))';
    it = -Rt*F(1:3);
    
    if nargout > 2
        Pc = q2Pi(q2qc(F(4:7)));
    end
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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

