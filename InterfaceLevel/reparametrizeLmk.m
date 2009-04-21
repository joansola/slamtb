function [Lmk,Obs] = reparametrizeLmk(Rob,Sen,Lmk,Obs,Opt)

%REPARAMETRIZELMK Reparametrize landmark.
% TODO: help

global Map

switch Lmk.type
    case 'idpPnt' % TODO: the IDP --> EUC case
        
        %         Test for linearity:
        Ld = xyzLinTest(Rob,Sen,Lmk);
        
        if Ld < Opt.correct.linTestTh
            
            ir = Lmk.state.r;
            idp = Map.x(ir);
            [p,P_i] = idp2p(idp);
            
            nir=ir(1:3);
            
            Map.x(nir) = p;
            
            m = Map.used;
            
            Map.P(nir,m) = P_i * Map.P(ir,m);
            Map.P(m,nir) = Map.P(m,ir) * P_i';
            
            
            
            Obs.ltype = 'eucPnt';
            
            Lmk.type = 'eucPnt';
            Map.used(Lmk.state.r(4:6)) = false;
            Lmk.state.r = Lmk.state.r(1:3);
            
        end
        
    case 'eucPnt'
        % do nothing
    otherwise
        error('??? Unknown landmark type ''%s''.',Lmk.type)
end
