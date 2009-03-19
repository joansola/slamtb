function SimLmk = createSimLmk(World)

% CREATESIMLMK  Create a set of landmarks for simulation.
%   SIMLMK = CREATESIMLMK(World) creates the simulation structure SIMLMK
%   from information contained in the user-defined World structure. See
%   userData.m for the specification of this input structure.

N            = size(World.points,2); % number of landmarks in the simulated world

SimLmk       = World;
SimLmk.ids   = 100+(1:N); % id is different than index
SimLmk.l     = SimLmk.xMax - SimLmk.xMin; % playground dimensions
SimLmk.w     = SimLmk.yMax - SimLmk.yMin;
SimLmk.h     = SimLmk.zMax - SimLmk.zMin;
SimLmk.xMean = (SimLmk.xMax + SimLmk.xMin)/2; % center fo playground
SimLmk.yMean = (SimLmk.yMax + SimLmk.yMin)/2;
SimLmk.zMean = (SimLmk.zMax + SimLmk.zMin)/2;
