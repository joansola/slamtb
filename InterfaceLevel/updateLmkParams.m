function Lmk = updateLmkParams(Rob,Sen,Lmk,Obs,Opt)

% UPDATELMKPARAMS Update off-filter landmark parameters.

switch Sen.type

    case 'pinHole'

        switch Lmk.type
            case {'eucPnt','idpPnt','hmgPnt'}
                % do nothing

            case 'plkLin'
                % update endpoints
                Lmk = updatePlkLinEndPnts(Rob,Sen,Lmk,Obs,Opt);

            otherwise
                error('??? Unknown landmark type ''%s''.',Lmk.type)
        end

    otherwise
        error('??? Unknown sensor type ''%s''.',Sen.type)
end

