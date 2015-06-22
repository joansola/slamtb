function [Lmk,Trj,Frm,Fac] = addFrmToTrj(Lmk,Trj,Frm,Fac)

% ADDFRMTOTRJ Add frame to trajectory
%   [Trj,Frm,Fac] = ADDFRMTOTRJ(Trj,Frm,Fac) Adds a frame to the trajectory
%   Trj. It does so by advancing the HEAD pointer in the trajectory Trj,
%   and clearing sensitive data in the frame pointed by the new HEAD.
%
%   The trajectory is a circular array, so when all positions are full,
%   adding a new frame overwrites the oldest one. In such case, all factors
%   linking to the discarded frame are cleared.
%
%   The added frame is empty, and only its ID is created, distinct to all
%   other IDs.

% Advance HEAD
Trj.head = mod(Trj.head, Trj.maxLength) + 1;

% Update TAIL
if Trj.length < Trj.maxLength

    % Trj is not yet full. Just lengthen.
    Trj.length = Trj.length + 1;

else
    % Trj is full. Tail frame will be overwritten !!
    
    % Remove tail frame and cleanup graph
    [Lmk,Trj,Frm,Fac] = removeFrm(Lmk,Trj,Frm,Fac);
    
    % Advance TAIL
    Trj.tail = mod(Trj.tail, Trj.maxLength) + 1;    
    
end

% Complete the new frame with no factors
Frm(Trj.head).used    = true;
Frm(Trj.head).id      = newId;
Frm(Trj.head).factors = [];

% % Query and Block positions in Map
% r = newRange(Frm(Trj.head).
% Map.used(Frm(Trj.head).state.r) = true;


end

function [Lmk,Trj,Frm,Fac] = removeFrm(Lmk,Trj,Frm,Fac)

global Map

    % Delete factors from factors lists in Frm and Lmk
    factors = Frm(Trj.tail).factors;
    for fac = factors
        for frm = [Fac(fac).frames];
            Frm(frm).factors([Frm(frm).factors] == fac) = [];
        end
        for lmk = [Fac(fac).lmk]
            Lmk(lmk).factors([Lmk(lmk).factors] == fac) = [];
            % Delete landmark if no factors support it
            if isempty(Lmk(lmk).factors)
                % TODO: Use deleteLmk, which also updates Obs. 
                % Need Obs in the API.
                Lmk(lmk).used = false;
                Map.used(Lmk(lmk).state.r) = false;

            end
        end
        
    end

    % Free (and cleanup just in case) factors from tail before advancing
    [Fac(factors).used] = deal(false);
    [Fac(factors).frames] = deal([]);
    [Fac(factors).lmk] = deal([]);

    % Clean discarded tail frame
    Frm(Trj.tail).used = false;
    
    % Unblock positions in Map
    Map.used(Frm(Trj.tail).state.r)    = false;


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

