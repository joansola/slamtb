function world = initWorld(lim)

% INITWORLD  Initialize world structure and dimensions


% World dimensions
world.xMin  = -4;
world.xMax  =  30;
world.yMin  = -20;
world.yMax  =  20;
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

