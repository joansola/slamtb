% INITWORLD  Initialize world structure and dimensions


% World dimensions
world.xMin  = -20;
world.xMax  =  20;
world.yMin  = -4;
world.yMax  =  36;
world.zMin  = -10;
world.zMax  =  10;
world.l     = world.xMax - world.xMin;
world.w     = world.yMax - world.yMin;
world.h     = world.zMax - world.zMin;
world.xMean = (world.xMax + world.xMin)/2;
world.yMean = (world.yMax + world.yMin)/2;
world.zMean = (world.zMax + world.zMin)/2;


% World structure - for simulation purposes
world.points   = zeros(3,0);
world.segments = fromFrameSegment([4;8;0;e2q([0;0;pi/2])],house(0,0,0,8,8,5));
% world.segments = XZRectangle(-4,4,8,0,4);
% world.segments = zSegment(-4,8,0,4);

% redefine maxLine according to world size
maxLine = size(world.segments,2);
