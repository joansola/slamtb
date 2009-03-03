function Wrd = createWorld(World)

Wrd = World;
Wrd.l     = Wrd.xMax - Wrd.xMin;
Wrd.w     = Wrd.yMax - Wrd.yMin;
Wrd.h     = Wrd.zMax - Wrd.zMin;
Wrd.xMean = (Wrd.xMax + Wrd.xMin)/2;
Wrd.yMean = (Wrd.yMax + Wrd.yMin)/2;
Wrd.zMean = (Wrd.zMax + Wrd.zMin)/2;
