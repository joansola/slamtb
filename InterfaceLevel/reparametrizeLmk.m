function [Lmk,Obs] = reparametrizeLmk(Rob,Sen,Lmk,Obs,Opt)

%REPARAMETRIZELMK Reparametrize landmark.
%   [LMK,OBS] = REPARAMETRIZELMK(ROB,SEN,LMK,OBS,OPT) return the
%   reparametrized landmark and Obs structure.
%   The landmark is reparametrized only in the case of an inverse depth 
%   point. A linearity test of cartesian point given inverse depth 
%   point is performed.

%   Copyright 2009 David Marquez @ LAAS-CNRS.


global Map

switch Lmk.type
    
    case 'idpPnt' 
        % we will convert from inverse-depth to euclidean.
        
        % Test for linearity:
        Ld = idpLinearTest(Rob,Sen,Lmk);
        
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
        
    case 'ahmPnt' 
        % we will convert from anchored homogeneous to euclidean.
        
        % Test for linearity:
        Ld = ahmLinearTest(Rob,Sen,Lmk);
        
        if Ld < Opt.correct.linTestIdp
            
            % ranges
            ar  = Lmk.state.r;  % ahmPnt
            er  = ar(1:3);      % euclidean
            m   = Map.used;     % map
            
            % point coordinates
            ahm     = Map.x(ar);   % idp
            [p,P_a] = ahm2euc(ahm);  % euclidean
            
            % map updates
            Map.x(er)   = p;     % mean
            
            Map.P(er,m) = P_a * Map.P(ar,m); % co- and cross-variances
            Map.P(m,er) = Map.P(m,ar) * P_a';
            
            Map.used(Lmk.state.r(4:7)) = false; % used positions
            
            % Lmk and Obs updates
            Lmk.state.r = er;    % new range
            Lmk.type  = 'eucPnt'; % new type
            Obs.ltype = 'eucPnt'; % new type
        end
        
    case {'eucPnt'}
        % do nothing
        
    case {'hmgPnt','ahmPnt','plkLin','aplLin','idpLin','ahmLin','hmgLin'}
        % do nothing, by now <- probably add here something to do
        % Points should go to euclidean
        % Lines should go to some minimal representation (polar? 'plrLin')
        
    % case 'myLmk' 
        % edit this 'myLmk' name to put your own landmark type
        % do something
        
    otherwise
        error('??? Unknown landmark type ''%s''.',Lmk.type)

end









