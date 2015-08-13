function [Lmk, Frm, Fac] = makeMeasFactor(Lmk, Obs, Frm, Fac, NFrms)

% MAKEMEASFACTOR Make measurement factor.
%
% [Lmk, Frm, Fac] = MAKEMEASFACTOR(Lmk, Obs, Frm, Fac) creates a new
% measurement factor Fac linking frame Frm to landmark Lmk, using the
% observation informaiton in Obs and the type in Lmk.
%
% [Lmk, Frm, Fac] = MAKEMEASFACTOR(Lmk, Obs, Frm, Fac, numFrames) creates a
% new measurement factor Fac linking a NFrms number of frames Frm to
% landmark Lmk, using the observation informaiton in Obs and the type in
% Lmk. The variable Frm should be a vector with NFrms elements. The
% landmark will always be the last element (this influenciates the index of
% range and jacobians)

%   Copyright 2015-     Joan Sola @ IRI-UPC-CSIC

if ~exist('NFrms','var')
    NFrms = 1;
end

if NFrms > 3
    error('Measurement factors linking to more than 3 frames is not yet supported! (NFrms == %s)',num2str(NFrms));
end

Fac.used = true; % Factor is being used ?
Fac.id = newId; % Factor unique ID

Fac.type = 'measurement'; % {'motion','measurement','absolute'}
Fac.rob = Frm(1).rob;
Fac.sen = Obs.sen;
Fac.lmk = Obs.lmk;
Fac.frames = [Frm.frm];

% Measurement is the straight data
Fac.meas.y = Obs.meas.y;
Fac.meas.R = Obs.meas.R;
Fac.meas.W = Obs.meas.R^-1; % measurement information matrix

% Expectation has zero covariance -- and info in not defined
Fac.exp.e = Fac.meas.y; % expectation
Fac.exp.E = zeros(size(Obs.meas.R)); % expectation cov
%     Fac.exp.W = Fac.meas.W; % expectation information matrix

% Error is zero at this stage, and takes covariance and info from measurement
Fac.err.z     = zeros(size(Fac.meas.y)); % error or innovation (we call it error because we are on graph SLAM)
Fac.err.Z     = Fac.meas.R;              % error cov matrix
Fac.err.W     = Fac.meas.W;              % error information matrix
Fac.err.Wsqrt = chol(Fac.err.W);

% Ranges and Jacobians and update factors lists
% NOTE: Jacobians are zero at this stage. Just make size correct.
% TODO: this switch could be implicit by using the number of elements in the Frm vector
switch NFrms
    case 1
        % range
        Fac.state.r1 = Frm(1).state.r;
        Fac.state.r2 = Lmk.state.r;
        Fac.state.r3 = [];
        % jacobians
        Fac.err.J1 = Obs.Jac.E_r; % Jac. of error wrt. node 1 - robot pose
        Fac.err.J2 = Obs.Jac.E_l; % Jac. of error wrt. node 2 - lmk state
        Fac.err.J3 = zeros(size(Fac.meas.y)); % not used
        % Append factor to Frame's and Lmk's factors lists.
        Frm(1).factors = [Frm(1).factors Fac.fac]; 
        Lmk.factors = [Lmk.factors Fac.fac];

    case 2
        % range
        Fac.state.r1 = Frm(1).state.r;
        Fac.state.r2 = Frm(2).state.r;
        Fac.state.r3 = Lmk.state.r;
        % jacobians
        Fac.err.J1 = Obs.Jac.E_r; % Jac. of error wrt. node 1 - frame 1
        Fac.err.J2 = Obs.Jac.E_r; % Jac. of error wrt. node 2 - frame 2
        if strcmp(Lmk.type,'idpPnt')
            Fac.err.J3 = Obs.Jac.E_l(:,4:6); % Jac. of error wrt. node 3 - idp lmk state without anchor
        else
            Fac.err.J3 = Obs.Jac.E_l; % Jac. of error wrt. node 3 - lmk state
        end
        
        % Append factor to Frame's and Lmk's factors lists.
        Frm(1).factors = [Frm(1).factors Fac.fac]; 
        Frm(2).factors = [Frm(2).factors Fac.fac]; 
        Lmk.factors = [Lmk.factors Fac.fac];

    case 3
        % range
        Fac.state.r1 = Frm(1).state.r;
        Fac.state.r2 = Frm(2).state.r;
        Fac.state.r3 = Frm(3).state.r;
        Fac.state.r4 = Lmk.state.r;
        % jacobians
%         Fac.err.J1 = Obs.Jac.E_r; % Jac. of error wrt. node 1 - frame 1
%         Fac.err.J2 = Obs.Jac.E_r; % Jac. of error wrt. node 2 - frame 2
%         if strcmp(Lmk.type,'idpPnt')
%             Fac.err.J3 = Obs.Jac.E_l(:,4:6); % Jac. of error wrt. node 3 - idp lmk state without anchor
%         else
%             Fac.err.J3 = Obs.Jac.E_l; % Jac. of error wrt. node 3 - lmk state
%         end
        
        % Append factor to Frame's and Lmk's factors lists.
        Frm(1).factors = [Frm(1).factors Fac.fac]; 
        Frm(2).factors = [Frm(2).factors Fac.fac]; 
        Frm(3).factors = [Frm(3).factors Fac.fac]; 
        Lmk.factors = [Lmk.factors Fac.fac];

end

Fac.err.size  = numel(Fac.err.z);

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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

