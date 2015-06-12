function [Lmk,Obs] = initLmkParams(Rob,Sen,Lmk,Obs)

% INITLMKPARAMS  Initialize off-filter landmark parameters.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

% Init internal state
switch Lmk.type
    case {'eucPnt','idpPnt','hmgPnt','ahmPnt'}
    case 'plkLin'
        l  = Map.x(Lmk.state.r);
        t1 = -8;
        t2 =  8;
        Lmk.par.endp(1).t = t1;
        Lmk.par.endp(2).t = t2;
        [e1,e2] = pluckerEndpoints(l, t1, t2);
        Lmk.par.endp(1).e = e1;
        Lmk.par.endp(2).e = e2;

        %             [seg, t] = retroProjPlkEndPnts(Rob,Sen,Lmk,Obs);
        %             Lmk.par.endp(1).t = t(1);
        %             Lmk.par.endp(2).t = t(2);
        %             Lmk.par.endp(1).e = seg(1:3);
        %             Lmk.par.endp(2).e = seg(4:6);

        Obs.par.endp(1).e = Obs.meas.y(1:2);
        Obs.par.endp(2).e = Obs.meas.y(3:4);
        Obs.par.endp(1).E = Obs.meas.R(1:2,1:2);
        Obs.par.endp(2).E = Obs.meas.R(3:4,3:4);


    case 'aplLin'
        al  = Map.x(Lmk.state.r);
        l = unanchorPlucker(al);
        t1 = -8;
        t2 =  8;
        Lmk.par.endp(1).t = t1;
        Lmk.par.endp(2).t = t2;
        [e1,e2] = pluckerEndpoints(l, t1, t2);
        Lmk.par.endp(1).e = e1;
        Lmk.par.endp(2).e = e2;

        %             [seg, t] = retroProjPlkEndPnts(Rob,Sen,Lmk,Obs);
        %             Lmk.par.endp(1).t = t(1);
        %             Lmk.par.endp(2).t = t(2);
        %             Lmk.par.endp(1).e = seg(1:3);
        %             Lmk.par.endp(2).e = seg(4:6);

        Obs.par.endp(1).e = Obs.meas.y(1:2);
        Obs.par.endp(2).e = Obs.meas.y(3:4);
        Obs.par.endp(1).E = Obs.meas.R(1:2,1:2);
        Obs.par.endp(2).E = Obs.meas.R(3:4,3:4);
        
    case 'idpLin'
        l  = Map.x(Lmk.state.r);
        Lmk.par.endp(1).t = 0;
        Lmk.par.endp(2).t = 1;
        seg = idpLin2seg(l);
        Lmk.par.endp(1).e = seg(1:3);
        Lmk.par.endp(2).e = seg(4:6);
        Obs.par.endp(1).e = Obs.meas.y(1:2);
        Obs.par.endp(2).e = Obs.meas.y(3:4);
        Obs.par.endp(1).E = Obs.meas.R(1:2,1:2);
        Obs.par.endp(2).E = Obs.meas.R(3:4,3:4);
        

   case 'hmgLin'
        l  = Map.x(Lmk.state.r);
        Lmk.par.endp(1).t = 0;
        Lmk.par.endp(2).t = 1;
        seg = hmgLin2seg(l);
        Lmk.par.endp(1).e = seg(1:3);
        Lmk.par.endp(2).e = seg(4:6);
        Obs.par.endp(1).e = Obs.meas.y(1:2);
        Obs.par.endp(2).e = Obs.meas.y(3:4);
        Obs.par.endp(1).E = Obs.meas.R(1:2,1:2);
        Obs.par.endp(2).E = Obs.meas.R(3:4,3:4);

   case 'ahmLin'
        l  = Map.x(Lmk.state.r);
        Lmk.par.endp(1).t = 0;
        Lmk.par.endp(2).t = 1;
        seg = ahmLin2seg(l);
        Lmk.par.endp(1).e = seg(1:3);
        Lmk.par.endp(2).e = seg(4:6);
        Obs.par.endp(1).e = Obs.meas.y(1:2);
        Obs.par.endp(2).e = Obs.meas.y(3:4);
        Obs.par.endp(1).E = Obs.meas.R(1:2,1:2);
        Obs.par.endp(2).E = Obs.meas.R(3:4,3:4);

    otherwise
        error('??? Unknown landmark type ''%s''.',Lmk.type);
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

