function SimLmk = createSimLmk(World)

SimLmk = World;
SimLmk.l     = SimLmk.xMax - SimLmk.xMin;
SimLmk.w     = SimLmk.yMax - SimLmk.yMin;
SimLmk.h     = SimLmk.zMax - SimLmk.zMin;
SimLmk.xMean = (SimLmk.xMax + SimLmk.xMin)/2;
SimLmk.yMean = (SimLmk.yMax + SimLmk.yMin)/2;
SimLmk.zMean = (SimLmk.zMax + SimLmk.zMin)/2;
