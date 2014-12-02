function Obs = observationInnovation(Obs,innType)

% OBSERVATIONINNOVATION  Observation innovation.
%   Obs = OBSERVATIONINNOVATION(Obs,innType) updates the structure Obs.inn with the
%   innovation. The used fields are Obs.meas and Obs.exp.
%
%   For line landmarks, ie. when Obs.ltype = '???Lin', the function uses
%   the innovation space defined in innType.
%
%   See also INNOVATION, OBSERVEKNOWNLMKS.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch Obs.ltype(4:6)

    case 'Pnt'   % Use regular Euclidean innovation z = y - h(x)
        [Obs.inn.z, Obs.inn.Z, Obs.inn.iZ, Obs.inn.MD2, Z_e] = innovation(...
            Obs.meas.y, Obs.meas.R,...
            Obs.exp.e, Obs.exp.E);

    case 'Lin'   % Lines don't admit Euclidean innovation. Select one:
        switch innType % innovation type for segments
            case 'ortDst'
                [Obs.inn.z, Obs.inn.Z, Obs.inn.iZ, Obs.inn.MD2, Z_e] = innovation(...
                    Obs.meas.y, Obs.meas.R, ...
                    Obs.exp.e, Obs.exp.E,   ...
                    @hms2hh);

            case 'rhoThe'
                error('??? Line''s ''%s'' innovation not yet implemented.',innType)

            otherwise
                error('??? Unknown innovation type ''%s''.',innType);
        end

    otherwise
        error('??? Unknown landmark type ''%s''.',Obs.ltype);
end

% Jacobians of innovation - the chain rule
Obs.Jac.Z_r = Z_e * Obs.Jac.E_r;
Obs.Jac.Z_s = Z_e * Obs.Jac.E_s;
Obs.Jac.Z_l = Z_e * Obs.Jac.E_l;



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

