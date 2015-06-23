function Obs = createObservations(Sen,Opt)

% CREATEOBSERVATIONS Create Obs structure array.
%   Rob = CREATEOBSERVATIONS(Sen,Lmk) creates the Obs() structure array to
%   be used as SLAM data, from the information contained in Sen() and
%   Rob(). See the toolbox documentation for details on this structure.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

for sen = 1:numel(Sen)
    
    for lmk = 1:Opt.map.numLmks
        
        S = Sen(sen);
%         L = Lmk(lmk);
        
        O.sen       = sen;        % sensor index
        O.lmk       = lmk;        % landmark index.
        O.sid       = S.id;       % sensor id
        O.lid       = [];         % lmk id
        O.stype     = S.type;     % sensor type
        O.ltype     = '';         % lmk type
        O.meas.y    = [];         % observation
        O.meas.R = S.par.cov; % observation cov
        O.nom.n     = [];         % expected non-observable
        O.nom.N     = [];         % expected non-observable cov
        O.exp.e     = [];         % expectation mean
        O.exp.E     = [];         % expectation cov
        O.exp.um    = [];         % expectation uncertainty measure
        O.inn.z     = [];         % innovation
        O.inn.Z     = [];         % innovation cov
        O.inn.iZ    = [];         % inverse inn. cov
        O.inn.MD2   = 0;          % Mahalanobis distance squared
        O.app.pred  = [];         % predicted appearence
        O.app.curr  = [];         % current appearence
        O.app.sc    = 0;          % match score
        O.par       = [];         % other params
        O.vis       = false;      % lmk is visible?
        O.measured  = false;      % lmk has been measured?
        O.matched   = false;      % lmk has been matched?
        O.updated   = false;      % lmk has been updated?
        O.Jac.E_r   = [];         % Jac of expectation wrt robot state - Obs function
        O.Jac.E_s   = [];         % Jac of expectation wrt sensor
        O.Jac.E_l   = [];         % Jac of expectation wrt landmark
        O.Jac.Z_r   = [];         % Jac of innovation wrt robot state - Inn function
        O.Jac.Z_s   = [];         % Jac of innovation wrt sensor
        O.Jac.Z_l   = [];         % Jac of innovation wrt landmark
        
        Obs(sen,lmk) = O;
        
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

