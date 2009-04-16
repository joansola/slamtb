function Obs = matchFeature(Raw,Obs)

% MATCHFEATURE  Match feature.
% TODO: help

switch Raw.type

    case 'simu'

        id = Obs.lid;
        idx = find(Raw.data.appearance==id);

        if ~isempty(idx)
            Obs.meas.y   = Raw.data.points(:,idx);
            Obs.measured = true;
            Obs.matched  = true;
        else
            Obs.measured = false;
            Obs.matched  = false;
        end


        % case 'real'
        % TODO: the real case

    otherwise

        error('??? Unknown Raw data type ''%s''.',Raw.type)

end
