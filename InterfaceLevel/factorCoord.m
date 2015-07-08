function [motionC, measC] = factorCoord(Lmk,Frm,Fac)

nframes  = sum([Frm.used]);
nlmks    = sum([Lmk.used]);

% Motion
motionC = zeros(nframes,3);

% Measurements
measC = zeros(nframes+nlmks,3);

for fac = find([Fac.used])
    
    frames = Fac(fac).frames;
    lmk = Fac(fac).lmk;

    switch Fac(fac).type
        case'motion'
            motionC(frames(1),1:3) = Frm(frames(1)).state.x(1:3)';
            motionC(frames(2),1:3) = Frm(frames(2)).state.x(1:3)';
        case 'absolute'
        case 'measurement'
            measC(frames,1:3) = Frm(frames).state.x(1:3)';
            measC(lmk+nframes,1:3) = Lmk(lmk).state.x(1:3)';
    end

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

