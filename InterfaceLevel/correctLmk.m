function [Rob,Sen,Lmk,Obs] = correctLmk(Rob,Sen,Lmk,Obs,Opt)

% CORRECTLMK  Correct landmark.
%   [Rob,Sen,Lmk,Obs] = CORRECTLMK(Rob,Sen,Lmk,Obs,Opt) performs all
%   landmark correction steps in EKF SLAM: stochastic EKF correction,
%   landmark reparametrization, and non-stochastic landmark correction (for
%   landmark parameters not maintained in the stochastic map).

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% EKF correction
[Rob,Sen,Lmk,Obs] = ekfCorrectLmk(Rob,Sen,Lmk,Obs);

% Negative inverse distance correction
% Lmk = correctNegIdp(Lmk); % I DON'T LIKE THIS SOLUTION. Rather use a
% better isVisible() function.

% Transform to cheaper parametrization if possible
if Opt.correct.reparametrize
    [Lmk,Obs] = reparametrizeLmk(Rob,Sen,Lmk,Obs,Opt);
end

% Update off-filter parameters
Lmk = updateLmkParams(Rob,Sen,Lmk,Obs,Opt);

% update flags and info
Obs.updated = true;



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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

