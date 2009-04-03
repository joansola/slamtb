function handle = createSenPatch(Sen,colr,ax)

% CREATESENPATCH  Create sensor patch.
%   CREATESENPATCH(SEN,COLR) creates a patch graphics object for the sensor
%   SEN with color COLR on the current axes. The shape of the patch depends
%   on SEN.type. For unknown sensor types, the shape defaults to
%   CAMGRAPHICS, and a warning is issued. 
%
%   CREATESENPATCH(SEN,COLR,AX) creates the patch object at axes AX.
%
%   H = CREATESENPATCH(...) returns the handle to the patch object. Use
%   SET(H,'propertyname',propertyvalue,...) to modify the patch properties.
%
%   See also CAMGRAPHICS, SET, GET.

if nargin < 3
    ax = gca;
end

% select shape from type
switch Sen.type
    case 'pinHole'
        graph = camGraphics(0.1);
    otherwise
        warning('??? Unknown sensor type ''%s''.',Sen.type);
        graph = camGraphics(0.1);
end
% Simulated - green
handle = patch(...
    'parent',       ax,...
    'vertices',     graph.vert,...
    'faces',        graph.faces,...
    'facecolor',    colr,...
    'visible',      'on',...
    'userdata',     graph);

handle = drawObject(handle,Sen);


