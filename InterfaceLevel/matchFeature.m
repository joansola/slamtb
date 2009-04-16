function Obs = matchFeature(Raw,Obs)

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

    otherwise

        error('??? Unknown Raw data type ''%s''.',Raw.type)

end
