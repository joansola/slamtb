function [Rob,Lmk,Trj,Frm,Fac] = addKeyFrame(Rob,Lmk,Trj,Frm,Fac,factorRob, factorType)

% ADDKEYFRAME Add key frame to trajectory.
%   [Rob,Lmk,Trj,Frm,Fac] = ADDKEYFRAME(Rob,Lmk,Trj,Frm,Fac,factorRob,factorType)
%   adds a new frame Frm at the head of trajectory Trj. This new frame has
%   the pose of Rob. If the trajectory is full, the oldest frame is
%   deleted, and the graph is updated with the removal of all the necessary
%   pointers, factors, and, eventually, also the landmarks that have become
%   orphelin of any factor. It also creates the necessary factors linking
%   the new frame to the graph, and reserves space in the Map for the error
%   states of the new frame.
%
%   See also PRINTGRAPH, CHECKGRAPHINTEGRITY, ADDFRMTOTRJ.

%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.



% Add frame to trajectory
[Lmk,Trj,Frm,Fac] = addFrmToTrj(...
    Lmk,...
    Trj,...
    Frm,...
    Fac);

% Update new frame with Rob info
[Rob, Frm(Trj.head)] = rob2frm(...
    Rob,...
    Frm(Trj.head));

% Create motion factor
fac = find([Fac.used] == false, 1, 'first');

switch factorType
    
    case 'absolute'
        [Frm(Trj.head), Fac(fac)] = makeAbsFactor(...
            Frm(Trj.head), ...
            Fac(fac), ...
            Rob);
        
    case 'motion'
        head_old = mod(Trj.head - 2, Trj.maxLength) + 1;
        [Frm(head_old), Frm(Trj.head), Fac(fac)] = makeMotionFactor(...
            Frm(head_old), ...
            Frm(Trj.head), ...
            Fac(fac), ...
            factorRob);
        
    otherwise
        error('??? Unknown or invalid factor type ''%s''.', facType)
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

