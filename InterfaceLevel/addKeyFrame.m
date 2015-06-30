function [Rob,Lmk,Trj,Frm,Fac] = addKeyFrame(Rob,Lmk,Trj,Frm,Fac,factorRob, factorType)

global Map

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

