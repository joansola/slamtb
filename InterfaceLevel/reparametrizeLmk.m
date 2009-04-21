function [Lmk,Obs] = reparametrizeLmk(Rob,Sen,Lmk,Obs,Opt)

%REPARAMETRIZELMK Reparametrize landmark.
% TODO: help

global Map

switch Lmk.type
    case 'idpPnt' % TODO: the IDP --> EUC case

        %         Test for linearity:
        Ld = xyzLinTest(Rob,Sen,Lmk);

        if Ld < Opt.correct.linTestTh

            % ranges
            ir  = Lmk.state.r;  % idp
            nir = ir(1:3);      % euclidean
            m   = Map.used;     % map

            % point coordinates
            idp     = Map.x(ir);   % idp
            [p,P_i] = idp2p(idp);  % euclidean

            % map updates
            Map.x(nir) = p;     % mean

            Map.P(nir,m) = P_i * Map.P(ir,m); % co- and cross-variances
            Map.P(m,nir) = Map.P(m,ir) * P_i';
            
            Map.used(Lmk.state.r(4:6)) = false; % used positions
            
            % Lmk and Obs updates
            Lmk.state.r = nir;    % new range
            Lmk.type  = 'eucPnt'; % new type
            Obs.ltype = 'eucPnt'; % new type
            
        end

    case 'eucPnt'
        % do nothing
    otherwise
        error('??? Unknown landmark type ''%s''.',Lmk.type)
end
