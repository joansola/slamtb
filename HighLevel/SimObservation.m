
function  Obs = SimObservation(Rob, Sen, Obs, SimLmk)

% SIMOBSERVATION  Operate an observation with sumulated landmarks and
% simulated robot.
%   OBS = SIMOBSERVATION(ROB, SEN, OBS, SIMLMK) returns the Observation for
%   the robot ROB with the sensor SEN into the structure OBS for the
%   landmarks SIMLMK.
%
%   ROB is a structure containing the robot. SEN is a structure containing
%   the sensor. OBS is a structure containing the observation.
%
%


    switch Sen.type
        
        % camera pinHole
        case {'pinHole'}
            
            % TODO : ne pas faire de boucle sur chaque amer.
            for pos3dLmk = SimLmk.points(2:4,:)
                
                % TODO : faire la fonction
                projectEuclPntIntoPinHoleOnRob(Rob.frame, Sen.frame, Sen.par.k, Sen.par.d, pos3dLmk)
                % et l'appeller sans demander les jacobiennes.
                
            end
            
        % unknown
        % -------
        otherwise
            % Print an error and exit
            error(['Unknown sensor type. Cannot operate an simulated observation with ''',Sen.type,''' sensor ''',Sen.name,'''.']);
    end % and of the "switch" on sensor type
        
    



end
