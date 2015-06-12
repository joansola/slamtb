function [q,Q_la,Q_lb] = lines2Epoint(La,Lb)

% LINES2EPOINT Intersection point of 2 Plucker lines. Result in Euclidean.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

na = La(1:3);
nb = Lb(1:3);
vb = Lb(4:6);

if nargout == 1

    q = cross(na,nb)/dot(na,vb);

else % jac

    % work in homogeneous for easiear Jacobians
    
    [pe,PE_na,PE_nb] = crossJ(na,nb);
    [ph,PH_na,PH_vb] = dotJ(na,vb);

    p = [pe;ph];
    Z33 = zeros(3);
    Z13 = zeros(1,3);
    P_la = [PE_na Z33;PH_na Z13];
    P_lb = [PE_nb Z33;Z13 PH_vb];
    
    [q,Q_p] = hm2eu(p);
    
    Q_la = Q_p*P_la;
    
    Q_lb = Q_p*P_lb;
    
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

