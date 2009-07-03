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
        [Obs.inn.z, Obs.inn.Z, Obs.inn.iZ, Obs.inn.MD2, Z_e] = innovation(...
            Obs.meas.y, Obs.meas.R,...
            Obs.exp.e, Obs.exp.E);

    case 'Lin'
        switch innType % innovation type for segments
            case 'ortDst'
                [Obs.inn.z, Obs.inn.Z, Obs.inn.iZ, Obs.inn.MD2, Z_e] = innovation(...
                    Obs.meas.y, Obs.meas.R,...
                    Obs.exp.e, Obs.exp.E,@hms2hh);

            case 'rhoThe'
                error('??? Line''s ''%s'' innovation not yet implemented.',innType)
            otherwise
                error('??? Unknown innovation type ''%s''.',innType);
        end

    otherwise
        error('??? Unknown landmark type ''%s''.',Obs.ltype);
end

% Jacobians of innovation
Obs.Jac.Z_r = Z_e*Obs.Jac.E_r;
Obs.Jac.Z_s = Z_e*Obs.Jac.E_s;
Obs.Jac.Z_l = Z_e*Obs.Jac.E_l;

