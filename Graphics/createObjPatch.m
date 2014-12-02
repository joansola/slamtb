function handle = createObjPatch(Obj,colr,ax)

% CREATEOBJPATCH  Create object patch.
%   CREATEOBJPATCH(OBJ,COLR) creates a patch graphics object for the object
%   OBJ with color COLR on the current axes. The shape of the patch depends
%   on OBJ.type. It is an error if OBJ.type is an unknown type. Edit this
%   file to inspect the list of known object types.
%
%   CREATEOBJPATCH(OBJ,COLR,AX) creates the patch object at axes AX.
%
%   H = CREATEOBJPATCH(...) returns the handle to the patch object. Use
%   SET(H,'propertyname',propertyvalue,...) to modify the patch properties.
%
%   See also CAMGRAPHICS, SET, GET.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 3
    ax = gca;
end

% select shape from type
switch Obj.type
    case {'atrv','IMU'}
        graph = thickVehicle(0.8);
    case {'pinHole','omniCam'}
        % graph = camSimpleGraphics(0.1);
        graph = camGraphics(0.1);
    otherwise
        error('??? Unknown object type ''%s''.',Obj.type);
end

% create patch
handle = patch(...
    'parent',       ax,...
    'vertices',     graph.vert,...
    'faces',        graph.faces,...
    'facecolor',    colr,...
    'visible',      'on',...
    'userdata',     graph);

% draw it in Obj frame
handle = drawObject(handle,Obj);



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

