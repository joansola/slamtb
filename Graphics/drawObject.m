function  handle = drawObject(handle,Obj,frame)

%DRAWOBJECT Draw 3D object graphics.
%   RH = DRAWOBJECT(CH,Obj) updates graphics handle RH for an object Obj.
%   The object to be drawn in Obj.graphics, and the position Obj.frame.
%
%   RH = DRAWOBJECT(CH,Obj,F) ignores the Obj.frame and uses F instead.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


if nargin < 3
    F = Obj.frame;
else
    F = frame;
end

objGraph = get(handle,'userdata');

[te,Re]       = getTR(F);
Te                = repmat(te,1,size(objGraph.vert,1));
objGraph.vert     = objGraph.vert0*Re'+Te'; 

set(handle,'vertices',objGraph.vert);



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

