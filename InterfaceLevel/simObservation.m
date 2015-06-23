function  Raw = simObservation(SimRob, SimSen, SimLmk, Opt)

% SIMOBSERVATION Observe simulated landmarks.
%   RAW = SIMOBSERVATION(SIMROB,SIMSEN,SIMLMK) returns the raw data
%   captured for the sensor.
%       SIMROB: simulated robot structure 
%       SIMSEN: simulated sensor strucure
%       SIMLMK: simulated landmarks strucure
%
%   See also SIMMOTION PROJEUCPNTINTOPINHOLEONROB

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

Raw.type = 'simu';

switch SimSen.type
    
    case {'pinHole'}      % camera pinHole

        % Project virtual world's points
        [Raw.data.points.coord, s] = projEucPntIntoPinHoleOnRob(...
            SimRob.frame, ...
            SimSen.frame, ...
            SimSen.par.k, ...
            SimSen.par.d, ...
            SimLmk.points.coord);
        Raw.data.points.app  = SimLmk.points.id;
        
        % Add sensor noise
        Raw.data.points.coord = Raw.data.points.coord + ...
            SimSen.par.pixErr*randn(size(Raw.data.points.coord));

        % Remove non visible
        vis = isVisible(Raw.data.points.coord,s,SimSen.par.imSize);        
        Raw.data.points.coord(:, ~vis)  = [];
        Raw.data.points.app(~vis) = [];
        
        
        
        % Project virtual world's segments
        [Raw.data.segments.coord, s] = projSegLinIntoPinHoleOnRob(...
            SimRob.frame, ...
            SimSen.frame, ...
            SimSen.par.k, ...
            SimLmk.segments.coord);
        Raw.data.segments.app  = SimLmk.segments.id;
        
        % Add sensor noise
        Raw.data.segments.coord = Raw.data.segments.coord + ...
            SimSen.par.cov*randn(size(Raw.data.points.coord));

        % Remove non visible
        [Raw.data.segments.coord,vis] = visibleSegment( ...
            Raw.data.segments.coord,...
            s,...
            SimSen.par.imSize,...
            0,...                      % N pixels margin
            Opt.obs.lines.minLength);  % min segment length
        Raw.data.segments.coord(:, ~vis)  = [];
        Raw.data.segments.app(~vis) = [];

    case {'pinHoleDepth'}      % camera pinHole

        % Project virtual world's points
        Raw.data.points.coord = projEucPntIntoPhdOnRob(...
            SimRob.frame, ...
            SimSen.frame, ...
            SimSen.par.k, ...
            SimSen.par.d, ...
            SimLmk.points.coord);
        Raw.data.points.app  = SimLmk.points.id;
        
        % Add sensor noise
        Raw.data.points.coord = Raw.data.points.coord + ...
            SimSen.par.cov*randn(size(Raw.data.points.coord));

        % Remove non visible
        vis = isVisible(Raw.data.points.coord(1:2,:),Raw.data.points.coord(3,:),SimSen.par.imSize);        
        Raw.data.points.coord(:, ~vis)  = [];
        Raw.data.points.app(~vis) = [];
        
        
        % TODO: Lines not implemented for sensor type 'pihHoleDepth'
        
        %         % Project virtual world's segments
        Raw.data.segments.coord = [];
        %         [Raw.data.segments.coord, s] = projSegLinIntoPinHoleOnRob(...
        %             SimRob.frame, ...
        %             SimSen.frame, ...
        %             SimSen.par.k, ...
        %             SimLmk.segments.coord);
        %         Raw.data.segments.app  = SimLmk.segments.id;
        Raw.data.segments.app = [];
        %
        %         % Add sensor noise
        %         Raw.data.segments.coord = Raw.data.segments.coord + ...
        %             SimSen.par.pixErr*randn(size(Raw.data.segments.coord));
        %
        %         % Remove non visible
        %         [Raw.data.segments.coord,vis] = visibleSegment( ...
        %             Raw.data.segments.coord,...
        %             s,...
        %             SimSen.par.imSize,...
        %             0,...                      % N pixels margin
        %             Opt.obs.lines.minLength);  % min segment length
        %         Raw.data.segments.coord(:, ~vis)  = [];
        %         Raw.data.segments.app(~vis) = [];

    case {'omniCam'}      % Omnidirectional camera 

        % Project virtual world's points
        [Raw.data.points.coord, s] = projEucPntIntoOmniCamOnRob(...
            SimRob.frame, ...
            SimSen.frame, ...
            SimSen.par.k, ...
            SimSen.par.d, ...
            SimLmk.points.coord);
        Raw.data.points.app  = SimLmk.points.id;
        
        % Add sensor noise
        Raw.data.points.coord = Raw.data.points.coord + ...
            SimSen.par.pixErr*randn(size(Raw.data.points.coord));

        % Remove non visible
        vis = isVisible(Raw.data.points.coord,s,SimSen.par.imSize);        
        Raw.data.points.coord(:, ~vis)  = [];
        Raw.data.points.app(~vis) = [];
        
    otherwise
        % Print an error and exit
        error('??? Unknown sensor type ''%s''.',SimSen.type);
        
end % end of the "switch" on sensor type



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

