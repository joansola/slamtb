function [S_F,SF_f,SF_sw] = toFrameSegment(F,S_W)

% TOFRAMESEGMENT  Express in local frame a set of segments from global frame
%   TOFRAMESEGMENT(F,S_W)  takes the W-referenced segments matrix S_W and
%   returns it in frame F.
%   S_W is a segments matrix defined as
%       S_W  = [S_1 S_2 ... S_N], where
%       S_I  = [P_i1;P_i2]      are the segments
%       P_ij = [x_ij;y_ij;z_ij] are the segments' endpoints
%
%   F is either a structure containing at least:
%     t : frame position
%     q : frame orientation quaternion
%     Rt: transposed rotation matrix
%     Pc: Conjugated Pi matrix
%
%   or a 7-vector F = [t;q].
%
%   [S_F,SF_f,SF_sw] = ... returns the Jacobians of toFrameSegments:
%     SF_f:  wrt the frame
%     SF_sw: wrt the segment
%   Note that this is only available for single segments.
%
%   See also TOFRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


s = size(S_W,2); % number of points in input matrix

if s==1 % one segment

    S_F = [...
        toFrame(F,S_W(1:3))
        toFrame(F,S_W(4:6))];
   
    if nargout > 1 % Jacobians
        [P1_F,P1F_f,P1F_p1w] = toFrame(F,S_W(1:3,:));
        [P2_F,P2F_f,P2F_p2w] = toFrame(F,S_W(4:6,:));
        S_F = [P1_F;P2_F];
        SF_f = [P1F_f;P2F_f];
        SF_sw = blkdiag(P1F_p1w,P2F_p2w);
    end

else % multiple points
    
    S_F = [...
        toFrame(F,S_W(1:3,:))
        toFrame(F,S_W(4:6,:))];
    if nargout > 1
        warning('Can''t give Jacobians for multiple segments');
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

