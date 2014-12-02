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



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

