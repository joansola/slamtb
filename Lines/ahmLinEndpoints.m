function [e1, e2, E1_l, E2_l] = ahmLinEndpoints(l,t1,t2)

% AHMLINENDPOINTS  AHM line endpoints.
%   AHMLINENDPOINTS(L,T) returns the 3D Euclidean endpoint of the
%   AHM line L at abscissa T.
%
%   [E1,E2] = AHMLINENDPOINTS(L,T1,T2) returns two 3D Euclidean endpoints
%   at abscissas T1 and T2.
%
%   [e1,e2,E1_l,E2_l] = AHMLINENDPINTS(...) returns the Jacobians of the
%   endopints wrt L.
%
%   See also AHMLINSEGMENT, AHMLIN2SEG, AHMLIN2IDPPNTS.

%   Copyright 2009 Teresa Vidal.

if nargout <= 2

    % support segment
    s  = ahmLin2seg(l);

    % support points
    p1 = s(1:3);
    p2 = s(4:6);

    % endpoints
    e1 = (1-t1)*p1 + t1*p2;
    e2 = (1-t2)*p1 + t2*p2;

else
    
    [s, S_l] = ahmLin2seg(l);       % support segment
    
    p1 = s(1:3);                    % support points
    p2 = s(4:6);
    
    P1_l = S_l(1:3,:);              % jacobians of sup points
    P2_l = S_l(4:6,:);
    
    e1 = (1-t1)*p1 + t1*p2;         % endpoints
    e2 = (1-t2)*p1 + t2*p2;
    
    E1_p1 = 1-t1;                   % jacobians of endpoints
    E1_p2 = t1;
    E2_p1 = 1-t2;
    E2_p2 = t2;
    
    E1_l = E1_p1*P1_l + E1_p2*P2_l; % chain rule
    E2_l = E2_p1*P1_l + E2_p2*P2_l;

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

