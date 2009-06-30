function Obs = observationInnovation(Obs,innType)

% OBSERVATIONINNOVATION  Observation innovation.
%   Obs = OBSERVATIONINNOVATION(Obs,innType) updates the structure Obs.inn with the
%   innovation. The used fields are Obs.meas and Obs.exp.
%
%   For line landmarks, ie. when Obs.ltype = '???Lin', the function uses
%   the innovation space defined in innType.
%
%   See also INNOVATION, OBSERVEKNOWNLMKS.

switch Obs.ltype(4:6)

    case 'Pnt'
        [Obs.inn.z, Obs.inn.Z, Obs.inn.iZ, Obs.inn.MD2] = innovation(...
            Obs.meas.y, Obs.meas.R,...
            Obs.exp.e, Obs.exp.E);

    case 'Lin'
        switch innType % innovation type for segments
            case 'ortDst'
                error('??? Line''s ''%s'' innovation not yet implemented.',innType)
            case 'rhoThe'
                error('??? Line''s ''%s'' innovation not yet implemented.',innType)
            otherwise
                error('??? Unknown innovation type ''%s''.',innType);
        end
        
    otherwise
        error('??? Unknown landmark type ''%s''.',Obs.ltype);
end
