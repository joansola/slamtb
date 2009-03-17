function SimLmk = createSimLmk(World)

N            = size(World.points,2); % number of landmarks in the simulated world

SimLmk       = World;
SimLmk.ids   = 1:N;
SimLmk.l     = SimLmk.xMax - SimLmk.xMin; % playground dimensions
SimLmk.w     = SimLmk.yMax - SimLmk.yMin;
SimLmk.h     = SimLmk.zMax - SimLmk.zMin;
SimLmk.xMean = (SimLmk.xMax + SimLmk.xMin)/2; % center fo playground
SimLmk.yMean = (SimLmk.yMax + SimLmk.yMin)/2;
SimLmk.zMean = (SimLmk.zMax + SimLmk.zMin)/2;
