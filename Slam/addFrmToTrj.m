function [Trj,Frm,Fac] = addFrmToTrj(Trj,Frm,Fac)

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
    % Trj was full. Tail frame will be overwritten !!
    
    % Delete (and cleanup) factors from tail before advancing
    [Fac(Frm(Trj.tail).factors).used] = deal(false);
    [Fac(Frm(Trj.tail).factors).frames] = deal([]);
    [Fac(Frm(Trj.tail).factors).lmk] = deal([]);
    % TODO delete landmarks linked only by the tail frame
    % TODO Clear factors in all landmarks related to tail frame
    % FIXME we need to add Lmk to the API
    
    % Advance TAIL
    Trj.tail = mod(Trj.tail, Trj.maxLength) + 1;
    
    % Clear motion factors at new tail relating to older frames that have
    % disappeared
%     Frm(Trj.tail).factors = Frm(Trj.tail).factors(end);
    Frm(Trj.tail).factors(1) = [];
    
    
end

% Complete the new frame
Frm(Trj.head).id = newId;
Frm(Trj.head).factors = [];



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

