function  Raw = simObservation(SimRob, SimSen, SimLmk, Opt)

% SIMOBSERVATION Observe simulated landmarks.
%   RAW = SIMOBSERVATION(SIMROB,SIMSEN,SIMLMK) returns the raw data
%   captured for the sensor.
%       SIMROB: simulated robot structure 
%       SIMSEN: simulated sensor strucure
%       SIMLMK: simulated landmarks strucure
%
%   See also SIMMOTION PROJEUCPNTINTOPINHOLEONROB

%   (c) 2009 David Marquez @ LAAS-CNRS.

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
            SimSen.par.pixErr*randn(size(Raw.data.segments.coord));

        % Remove non visible
        [Raw.data.segments.coord,vis] = visibleSegment( ...
            Raw.data.segments.coord,...
            s,...
            SimSen.par.imSize,...
            10,...                     % 10 pix margin
            Opt.obs.lines.minLength);  % min 10 pixels long
        Raw.data.segments.coord(:, ~vis)  = [];
        Raw.data.segments.app(~vis) = [];
        
    otherwise
        % Print an error and exit
        error('??? Unknown sensor type ''%s''.',Sen.type);
        
end % end of the "switch" on sensor type


