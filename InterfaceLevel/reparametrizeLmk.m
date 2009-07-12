function [Lmk,Obs] = reparametrizeLmk(Rob,Sen,Lmk,Obs,Opt)

%REPARAMETRIZELMK Reparametrize landmark.
%   [LMK,OBS] = REPARAMETRIZELMK(ROB,SEN,LMK,OBS,OPT) return the
%   reparametrized landmark and Obs structure.
%   The landmark is reparametrized only in the case of an inverse depth 
%   point. A linearity test of cartesian point given inverse depth 
%   point is performed.

%   (c) 2009 David Marquez @ LAAS-CNRS.


global Map

switch Lmk.type
    
    case 'idpPnt' 
        % we will convert from inverse-depth to euclidean.
        
        % Test for linearity:
        Ld = xyzLinTest(Rob,Sen,Lmk);
        
        if Ld < Opt.correct.linTestIdp
            
            % ranges
            ir = Lmk.state.r;  % idp
            er = ir(1:3);      % euclidean
            m  = Map.used;     % map
            
            % point coordinates
            idp     = Map.x(ir);   % idp
            [p,P_i] = idp2euc(idp);  % euclidean
            
            % map updates
            Map.x(er) = p;     % mean
            
            Map.P(er,m) = P_i * Map.P(ir,m); % co- and cross-variances
            Map.P(m,er) = Map.P(m,ir) * P_i';
            
            Map.used(Lmk.state.r(4:6)) = false; % used positions
            
            % Lmk and Obs updates
            Lmk.state.r = er;    % new range
            Lmk.type  = 'eucPnt'; % new type
            Obs.ltype = 'eucPnt'; % new type
            
        end
        
    case {'eucPnt','hmgPnt','plkLin','aplLin'}
        % do nothing
        
        
    % case 'myLmk' 
        % edit this 'myLmk' name to put your own landmark type
        % do something
        
    otherwise
        error('??? Unknown landmark type ''%s''.',Lmk.type)

end
