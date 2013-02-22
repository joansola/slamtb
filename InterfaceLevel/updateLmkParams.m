function Lmk = updateLmkParams(Rob,Sen,Lmk,Obs,Opt)

% UPDATELMKPARAMS Update off-filter landmark parameters.
%   Lmk = UPDATELMKPARAMS(Rob,Sen,Lmk,Obs,Opt) updates the internal params
%   in Lmk.par, using fundamentally information from the last observation
%   Obs, and following the options in Opt. 
%
%   The function does nothing for punctual landmarks as they do not have
%   internal parameters. It is useful on the ocntrary to update line
%   endpoints in landmarks of the type ???Lin such as plkLin, aplLin,
%   idpLin or hmgLin.
%
%   This function should be called after EKFCORRECTLMK.
%
%   See also EKFCORRECTLMK, UPDATEPLKLINENDPNTS.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch Sen.type

    case 'pinHole'

        switch Lmk.type
            case {'eucPnt','idpPnt','hmgPnt','ahmPnt','fhmPnt'}
                % do nothing

            case 'plkLin'
                % update endpoints
                Lmk = updatePlkLinEndPnts(Rob,Sen,Lmk,Obs,Opt);
                
            case 'aplLin'
                % update endpoints
                Lmk = updateAplLinEndPnts(Rob,Sen,Lmk,Obs,Opt);

            case 'idpLin'
                Lmk = updateIdpLinEndPnts(Rob,Sen,Lmk,Obs,Opt);
                
            case 'hmgLin'
                Lmk = updateHmgLinEndPnts(Rob,Sen,Lmk,Obs,Opt);

            case 'ahmLin'
                Lmk = updateAhmLinEndPnts(Rob,Sen,Lmk,Obs,Opt);

            otherwise
                error('??? Unknown landmark type ''%s''.',Lmk.type)
        end

    case 'omniCam'
        switch Lmk.type
            case {'eucPnt','idpPnt','hmgPnt','ahmPnt','fhmPnt'}
                % do nothing
              
            otherwise
                error('??? Unknown landmark type ''%s''.',Lmk.type)
        end

    otherwise
        error('??? Unknown sensor type ''%s''.',Sen.type)
end










