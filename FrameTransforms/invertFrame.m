function [iF, IF_f] = invertFrame(F)

% INVERTFRAME  Invert frame.
%   INVERTFRAME(F)  gives the frame iF, inverse of F, so that its
%   composition is the origin frame:
%       O = COMPOSEFRAMES(F,iF) ==> O.x = [0 0 0 1 0 0 0]'
%
%   [iF, IF_f] = INVERTFRAME(F) returns tha Jacobian of the inversion.

if nargout == 1
    
    q = q2qc(F.q);
    t = -Rtp(F.q,F.t);
    iF.x = [t;q];
    iF = updateFrame(iF);
    
else
    
    [q, Q_q] = q2qc(F.q);
    [nt, nT_q, nT_t] = Rtp(F.q,F.t); % this should be -Rtp(). n** means negative.
    
    iF.x = [-nt;q];
    iF = updateFrame(iF);

%     IF_f = zeros(7);
    IF_f(1:3,1:3) = -nT_t;
    IF_f(1:3,4:7) = -nT_q;
    IF_f(4:7,4:7) = Q_q;
    
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

