function Obs = matchFeature(Sen,Raw,Obs)

% MATCHFEATURE  Match feature.
% 	Obs = MATCHFEATURE(Sen,Raw,Obs) matches one feature in Raw to the predicted
% 	feature in Obs.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch Raw.type

    case {'simu','dump'}

        switch Obs.ltype(4:6)
            case 'Pnt'
                rawDataLmks = Raw.data.points;
                R = Sen.par.pixCov;
            case 'Lin'
                rawDataLmks = Raw.data.segments;
                R = blkdiag(Sen.par.pixCov,Sen.par.pixCov);
            otherwise
                error('??? Unknown landmark type ''%s''.',Obs.ltype);
        end


        id  = Obs.lid;
        idx = find(rawDataLmks.app==id);

        if ~isempty(idx)
            Obs.meas.y   = rawDataLmks.coord(:,idx);
            Obs.meas.R   = R;
            Obs.measured = true;
            Obs.matched  = true;
        else
            Obs.meas.y   = zeros(size(Obs.meas.y));
            Obs.meas.R   = R;
            Obs.measured = false;
            Obs.matched  = false;
        end
        
        % case 'real'
        % TODO: the real case

    otherwise

        error('??? Unknown Raw data type ''%s''.',Raw.type)

end









