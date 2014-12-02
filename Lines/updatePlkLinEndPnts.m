function Lmk = updatePlkLinEndPnts(Rob,Sen,Lmk,Obs,Opt)

% UPDATEPLKLINENDPNTS  Update Plucker endpoints.
%   Lmk = UPDATEPLKLINENDPNTS(Rob,Sen,Lmk,Obs,Opt) updates endpoint
%   abscissas in Plucker line Lmk by using the last observation Obs and the
%   options in Opt.
%
%   See also UPDATELMKPARAMS, RETROPROJPLKENDPNTS.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


[seg, t] = retroProjPlkEndPnts(Rob,Sen,Lmk,Obs);

if Opt.correct.lines.extPolicy

    lambda = sqrt(svd(Obs.par.endp(1).E));

    if lambda(1) < Opt.correct.lines.extSwitch
        
        % extend endpoint 1
        if t(1) < Lmk.par.endp(1).t  
            Lmk.par.endp(1).t = t(1);
            Lmk.par.endp(1).e = seg(1:3);
        end

        % extend endpoint 2
        if t(2) > Lmk.par.endp(2).t  
            Lmk.par.endp(2).t = t(2);
            Lmk.par.endp(2).e = seg(4:6);
        end
        
    else
        Lmk.par.endp(1).t = t(1);
        Lmk.par.endp(2).t = t(2);
        Lmk.par.endp(1).e = seg(1:3);
        Lmk.par.endp(2).e = seg(4:6);
    end

else
%     Lmk.par.endp(1).t = t(1);
%     Lmk.par.endp(2).t = t(2);
%     Lmk.par.endp(1).e = seg(1:3);
%     Lmk.par.endp(2).e = seg(4:6);
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

