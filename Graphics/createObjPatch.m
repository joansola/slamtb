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
    case 'atrv'
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











