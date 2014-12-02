function [ahp, AHP_idp] = idp2ahp(idp)

% IDP2AHP IDP to AHP point transformation.
%   IDP2AHP(IDP) transforms the IDP point into its AHP representation.
%
%   [ahp, AHP_idp] = IDP2AHP(...) returns the Jacobian.

%   Copyright 2010 Joan Sola

x0 = idp(1:3,:);
py = idp(4:5,:);
r = idp(6,:);

if nargout == 1
    
    ahp = [x0; py2vec(py); r];
    
else
    
    if size(idp,2) == 1
        
        [v,V_py] = py2vec(py);
        ahp = [x0;v;r];
        AHP_idp = [...
            eye(3) zeros(3)
            zeros(3) V_py zeros(3,1)
            zeros(1,5) 1];
        
    else
        
        error ('Jacobians not defined for multiple idps.');
        
    end
    
end
        
return

%%
syms x y z e a r real
idp = [x;y;z;e;a;r];
[ahp,AHP_idp] = idp2ahp(idp);

simplify(AHP_idp - jacobian(ahp,idp))



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

