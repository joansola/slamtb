function [Rob,Lmk,Frm] = updateStates(Rob,Lmk,Frm)

% UPDATESTATES Update Frm and Lmk states based on computed error.
%   [Rob,Lmk,Frm] = UPDATESTATES(Rob,Lmk,Frm) updates the nominal states of
%   robots Rob, landmarks Lmk and frames Frm, by composing their nominal
%   states in Xxx.state.x with the computed error states in
%   Map.x(Xxx.state.r).
%
%   Each state is updated following a different procedure depending on its
%   type.
%
%   See also UPDATEKEYFRM.

% Copyright 2015-     Joan Sola @ IRI-UPC-CSIC.


global Map

for rob = [Rob.rob]
    for frm = [Frm(rob,[Frm(rob,:).used]).frm]
        Frm(rob,frm) = updateKeyFrm(Frm(rob,frm));
    end
%     Rob(rob) = frm2rob(Rob(rob), Frm(rob,Trj.head));
end
for lmk = [Lmk([Lmk.used]).lmk]
    switch Lmk(lmk).type
        case 'eucPnt'
            % Trivial composition -- no manifold stuff
            Lmk(lmk).state.x = Lmk(lmk).state.x + Map.x(Lmk(lmk).state.r);
        otherwise
            error('??? Unknown landmark type ''%s'' or Update not implemented.',Lmk.type)
    end
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

