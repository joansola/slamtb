
function  SimObs = SimObservation(SimRob, SimSen, SimLmk)

% SIMOBSERVATION  Simulated observation.
%   OBS = SIMOBSERVATION(ROB, SEN, OBS, SIMLMK) returns the Observation for
%   the robot ROB with the sensor SEN into the structure OBS for the
%   landmarks SIMLMK.
%
%   ROB is a structure containing the robot. SEN is a structure containing
%   the sensor. OBS is a structure containing the observation.
%
%


switch SimSen.type

    % camera pinHole
    case {'pinHole'}

        % project all
        [SimObs.points, s] = projectEuclPntIntoPinHoleOnRob(SimRob.frame, SimSen.frame, SimSen.par.k, SimSen.par.d, SimLmk.points);
        SimObs.ids = SimLmk.ids;
        
        % get visible
        front = (s>0);
        inimg = inSquare(SimObs.points,[0 SimSen.par.imSize(1) 0 SimSen.par.imSize(2)]);
        vis = front & inimg;
        
        % delete all non visible
        SimObs.points(:,~vis)=[];             
        SimObs.ids(~vis)=[];
        
        % unknown
        % -------
    otherwise
        % Print an error and exit
        error(['Unknown sensor type. Cannot operate an simulated observation with ''',Sen.type,''' sensor ''',Sen.name,'''.']);

end % end of the "switch" on sensor type


