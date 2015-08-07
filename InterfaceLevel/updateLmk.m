function Lmk = updateLmk(Lmk,Sen,Frms,Fac)

global Map

% Get state error from Map
dl = Map.x(Lmk.state.r);
Lmk.state.dx = dl;

% IMPORTANT: for anchored landmarks the frames should be already updated.
switch Lmk.type
    case 'eucPnt'
        % Trivial composition -- no manifold stuff
        Lmk.state.x = Lmk.state.x + dl;
    case 'idpPnt'
        % get some pointers
        rob = Fac(Lmk.anchorFac).rob;
        sen = Fac(Lmk.anchorFac).sen;
        frm = Fac(Lmk.anchorFac).frames(1);
        anchorpose = composeFrames(updateFrame(Frms(rob,frm).state),Sen(sen).frame);
        
        Lmk.state.x(1:3) = anchorpose.x(1:3);
        Lmk.state.x(4:6) = Lmk.state.x(4:6) + dl;
    case 'hmgPnt'
        Lmk.state.x = composeHmgPnt(Lmk.state.x, dl);
    otherwise
        error('??? Unknown landmark or update not yet implemented landmark type ''%s''.',Lmk.type)
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

