function  Raw = simObservation(SimRob, SimSen, SimLmk)

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
    
    % camera pinHole
    case {'pinHole'}
        
        [Raw.data.points, s] = projEucPntIntoPinHoleOnRob(SimRob.frame, SimSen.frame, SimSen.par.k, SimSen.par.d, SimLmk.points);
        Raw.data.appearance  = SimLmk.ids;
        
        vis = isVisible(Raw.data.points,s,SimSen.par.imSize);
        
        Raw.data.points(:, ~vis)  = [];
        Raw.data.appearance(~vis) = [];
        
%         Raw.data.points = Raw.data.points + SimSen.par.pixErr*randn(size(Raw.data.points));
        % unknown
        % -------
    otherwise
        % Print an error and exit
        error('??? Unknown sensor type ''%s''.',Sen.type);
        
end % end of the "switch" on sensor type


