function handle = createRobPatch(Rob,colr,ax)

% CREATEROBPATCH  Create robot patch.
%   CREATEROBPATCH(ROB,COLR) creates a patch graphics object for the robot
%   ROB with color COLR on the current axes. The shape of the patch depends
%   on ROB.type. For unknown robot types, the shape defaults to
%   THICKVEHICLE, and a warning is issued. 
%
%   CREATEROBPATCH(ROB,COLR,AX) creates the patch object at axes AX.
%
%   H = CREATEROBPATCH(...) returns the handle to the patch object. Use
%   SET(H,'propertyname',propertyvalue,...) to modify the patch properties.
%
%   See also THICKVEHICLE, SET, GET.

if nargin < 3
    ax = gca;
end

% select shape from type
switch Rob.type
    case 'atrv'
        graph = thickVehicle(0.8);
    otherwise
        warning('??? Unknown robot type ''%s''.',Rob.type);
        graph = thickVehicle(0.8);
end
% Simulated - green
handle = patch(...
    'parent',       ax,...
    'vertices',     graph.vert,...
    'faces',        graph.faces,...
    'facecolor',    colr,...
    'visible',      'on',...
    'userdata',     graph);

handle = drawObject(handle,Rob);


