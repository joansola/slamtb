function Obs = matchFeature(Raw,Obs)

% MATCHFEATURE  Match feature.
% 	Obs = MATCHFEATURE(Raw,Obs) matches one feature in Raw to the predicted
% 	feature in Obs.


switch Raw.type

    case 'simu'

        switch Obs.ltype(4:6)
            case 'Pnt'
                rawDataLmks = Raw.data.points;
            case 'Lin'
                rawDataLmks = Raw.data.segments;
            otherwise
                error('??? Unknown landmark type ''%s''.',Obs.ltype);
        end


        id  = Obs.lid;
        idx = find(rawDataLmks.app==id);

        if ~isempty(idx)
            Obs.meas.y   = rawDataLmks.coord(:,idx);
            Obs.measured = true;
            Obs.matched  = true;
        else
            Obs.meas.y   = zeros(size(Obs.meas.y));
            Obs.measured = false;
            Obs.matched  = false;
        end
        % case 'real'
        % TODO: the real case

    otherwise

        error('??? Unknown Raw data type ''%s''.',Raw.type)

end
