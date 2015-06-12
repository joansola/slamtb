function Lmk = updateHmgLinEndPnts(Rob,Sen,Lmk,Obs,Opt)

% UPDATEHMGLINENDPNTS  Update HMG line endpoints.

%   Copyright 2009 Teresa Vidal.


global Map

% 3D landmark, IDL is Inverse Depth Line
idl = Map.x(Lmk.state.r); % This is the inverse depth line vector
seg = hmgLin2seg(idl);  % segment of support points
L   = seg2pvLin(seg);   % this is a point-vector line

% measured segment
s  = Obs.meas.y; % This is the measured segment, a 4-vector [x1;y1;x2;y2].
u1 = s(1:2);     % this is one endpoint
u2 = s(3:4);     % this is the other endpoint



% optical ray
x0 = fromFrame(Rob.frame,Sen.frame.t);  % this is optical centre in world frame
R  = Rob.frame.R*Sen.frame.R;      % Rob and Sen rotations, composed
v1 = R*invPinHole(u1,1,Sen.par.k); % the first vector
v2 = R*invPinHole(u2,1,Sen.par.k); % the second vector


a = [vecsAngle(v1,(seg(4:6)-seg(1:3)))
    vecsAngle(v2,(seg(4:6)-seg(1:3)))];

if  all(a > pi/4)

    % point-vector forms of optical rays
    R1 = [x0;v1]; % optical ray of first observed endpoint
    R2 = [x0;v2]; % optical ray of second observed endpoint

    % intersections
    [T1,P11] = intersectPvLines(L,R1); % line with optical ray 1
    [T2,P21] = intersectPvLines(L,R2); % line with optical ray 2

    t1 = T1(1); % take only the abcissa in landmark line
    t2 = T2(1); % (only abcissa in landmark line is of any interest)

    % put always the smallest abscissa first:
    if t1>t2
        t = [t2;t1]; % t is now a vector with the 2 abscissas
    else
        t = [t1;t2];
    end

    % here we should see if the new abscissas make the segment longer or not.
    % This is already programmed somewhere in Jafar. I leave it like t_new = t:
    if Opt.correct.lines.extPolicy
        % extend endpoint 1
        if t(1) < Lmk.par.endp(1).t
            Lmk.par.endp(1).t = t(1);
            Lmk.par.endp(1).e = P11;
        end

        % extend endpoint 2
        if t(2) > Lmk.par.endp(2).t
            Lmk.par.endp(2).t = t(2);
            Lmk.par.endp(2).e = P21;
        end
    end

end

return

%% test - previous
slamrc
% run slamtb and stop after creating SLAM structures
Rob=Rob(1); Rob.frame.x = [0;0;0;1;0;0;0]; Rob.frame = updateFrame(Rob.frame);
Sen=Sen(1); Sen.frame.x = [0;0;0;.5;-.5;.5;-.5]; Sen.frame = updateFrame(Sen.frame);
Lmk=Lmk(1);
Obs=Obs(1,1);

%% test 1
% lmk
p0 = [1;1;1];
p1 = [10;5;1];
p2 = [10;-5;1];
Lmk.state.x = ppp2idl(p0,p1,p2);

% obs
e1 = projEucPntIntoPinHoleOnRob(Rob.frame,Sen.frame,Sen.par.k,Sen.par.d,p1) + randn(2,1);
e2 = projEucPntIntoPinHoleOnRob(Rob.frame,Sen.frame,Sen.par.k,Sen.par.d,p2) + randn(2,1);
Obs.meas.y = [e1;e2];

% abscissas
Lmk = updateHmgLinEndPnts(Rob,Sen,Lmk,Obs);

% print
Lmk.par.endpoints.abscissas
Lmk.par.endpoints.p1
Lmk.par.endpoints.p2



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

