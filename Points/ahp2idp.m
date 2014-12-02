function [idp, IDP_ahp] = ahp2idp(ahp)

% AHP2IDP IDP to AHP point transformation.
%   AHP2IDP(IDP) transforms the IDP point into its AHP representation.
%
%   [ahp, AHP_idp] = AHP2IDP(...) returns the Jacobian.

%   Copyright 2010 Joan Sola

x0 = ahp(1:3,:);
v  = ahp(4:6,:);
r  = ahp(7,:);

if nargout == 1
    
    idp = [x0; vec2py(v); r];
    
else
    
    if size(ahp,2) == 1
        
        [py,PY_v] = vec2py(v);
        idp = [x0;py;r];
        IDP_ahp = [...
            eye(3) zeros(3,4)
            zeros(2,3) PY_v zeros(2,1)
            zeros(1,6) 1];
        
    else
        
        error ('Jacobians not defined for multiple ahps.');
        
    end
    
end
        
return

%%
syms x y z u v w r real
ahp = [x;y;z;u;v;w;r];
[idp,IDP_ahp] = ahp2idp(ahp);

simplify(IDP_ahp - jacobian(idp,ahp))



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

