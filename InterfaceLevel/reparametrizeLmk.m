function [Lmk,Obs] = reparametrizeLmk(Lmk,Obs)

%REPARAMETRIZELMK Reparametrize landmark.
% TODO: help

global Map

switch Lmk.type
    case 'idpPnt' % TODO: the IDP --> EUC case
        % 1. test linearity
        % 2. reparametrize IDP->EUC - mean and Jacobians
        % [p,P_i] = idp2p(idp);
        % 3. reparametrize - covariances.

    case 'eucPnt'
        % do nothing
    otherwise
        error('??? Unknown landmark type ''%s''.',Lmk.type)
end
