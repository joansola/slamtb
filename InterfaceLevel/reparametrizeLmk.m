function [Lmk,Obs] = reparametrizeLmk(Lmk,Obs,Opt)

%REPARAMETRIZELMK Reparametrize landmark.
% TODO: help

global Map

switch Lmk.type
    case 'idpPnt' % TODO: the IDP --> EUC case
        % 1. test linearity
        doReparam = idp2pLinTest();
        if (doReparam)
            % 2. reparametrize IDP->EUC - mean and Jacobians
            idp = Map.x(Lmk.state.r) ;
            [p,P_i] = idp2p(idp);
            % 3. reparametrize - covariances.
            
        end;

    case 'eucPnt'
        % do nothing
    otherwise
        error('??? Unknown landmark type ''%s''.',Lmk.type)
end
