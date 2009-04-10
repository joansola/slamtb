function  Raw = simObservation(SimRob, SimSen, SimLmk)

% SIMOBSERVATION  Simulated observation.
%   RAW = SIMOBSERVATION(ROB, SEN, OBS, SIMLMK) returns the Observation for
%   the robot ROB with the sensor SEN into the structure OBS for the
%   landmarks SIMLMK.
%
%   ROB is a structure containing the robot. SEN is a structure containing
%   the sensor. OBS is a structure containing the observation.
%

Raw.type = 'simu';

switch SimSen.type
    
    % camera pinHole
    case {'pinHole'}
        
        [Raw.data.points, s] = projEucPntIntoPinHoleOnRob(SimRob.frame, SimSen.frame, SimSen.par.k, SimSen.par.d, SimLmk.points);
        Raw.data.ids = SimLmk.ids;
        
        vis = isVisible(Raw.data.points,s,SimSen.par.imSize);
        
        Raw.data.points(:, ~vis) = [];
        Raw.data.ids(~vis) = [];
        % unknown
        % -------
    otherwise
        % Print an error and exit
        error(['Unknown sensor type. Cannot operate an simulated observation with ''',Sen.type,''' sensor ''',Sen.name,'''.']);
        
end % end of the "switch" on sensor type


