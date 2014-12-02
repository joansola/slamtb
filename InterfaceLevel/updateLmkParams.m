function Lmk = updateLmkParams(Rob,Sen,Lmk,Obs,Opt)

% UPDATELMKPARAMS Update off-filter landmark parameters.
%   Lmk = UPDATELMKPARAMS(Rob,Sen,Lmk,Obs,Opt) updates the internal params
%   in Lmk.par, using fundamentally information from the last observation
%   Obs, and following the options in Opt. 
%
%   The function does nothing for punctual landmarks as they do not have
%   internal parameters. It is useful on the ocntrary to update line
%   endpoints in landmarks of the type ???Lin such as plkLin, aplLin,
%   idpLin or hmgLin.
%
%   This function should be called after EKFCORRECTLMK.
%
%   See also EKFCORRECTLMK, UPDATEPLKLINENDPNTS.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch Sen.type

    case 'pinHole'

        switch Lmk.type
            case {'eucPnt','idpPnt','hmgPnt','ahmPnt','fhmPnt'}
                % do nothing

            case 'plkLin'
                % update endpoints
                Lmk = updatePlkLinEndPnts(Rob,Sen,Lmk,Obs,Opt);
                
            case 'aplLin'
                % update endpoints
                Lmk = updateAplLinEndPnts(Rob,Sen,Lmk,Obs,Opt);

            case 'idpLin'
                Lmk = updateIdpLinEndPnts(Rob,Sen,Lmk,Obs,Opt);
                
            case 'hmgLin'
                Lmk = updateHmgLinEndPnts(Rob,Sen,Lmk,Obs,Opt);

            case 'ahmLin'
                Lmk = updateAhmLinEndPnts(Rob,Sen,Lmk,Obs,Opt);

            otherwise
                error('??? Unknown landmark type ''%s''.',Lmk.type)
        end

    case 'omniCam'
        switch Lmk.type
            case {'eucPnt','idpPnt','hmgPnt','ahmPnt','fhmPnt'}
                % do nothing
              
            otherwise
                error('??? Unknown landmark type ''%s''.',Lmk.type)
        end

    otherwise
        error('??? Unknown sensor type ''%s''.',Sen.type)
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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

