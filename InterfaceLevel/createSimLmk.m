function SimLmk = createSimLmk(World)

% CREATESIMLMK  Create a set of landmarks for simulation.
%   SIMLMK = CREATESIMLMK(World) creates the simulation structure SIMLMK
%   from information contained in the user-defined World structure. See
%   userData.m for the specification of this input structure.

N            = size(World.points,2); % number of landmarks in the simulated world


SimLmk.ids          = (1:N); % id is different than index
SimLmk.points       = World.points;
SimLmk.lims.xMin    = World.xMin;
SimLmk.lims.xMax    = World.xMax;
SimLmk.lims.yMin    = World.yMin;
SimLmk.lims.yMax    = World.yMax;
SimLmk.lims.zMin    = World.zMin;
SimLmk.lims.zMax    = World.zMax;
SimLmk.dims.l       = SimLmk.lims.xMax - SimLmk.lims.xMin; % playground dimensions
SimLmk.dims.w       = SimLmk.lims.yMax - SimLmk.lims.yMin;
SimLmk.dims.h       = SimLmk.lims.zMax - SimLmk.lims.zMin;
SimLmk.center.xMean = (SimLmk.lims.xMax + SimLmk.lims.xMin)/2; % center fo playground
SimLmk.center.yMean = (SimLmk.lims.yMax + SimLmk.lims.yMin)/2;
SimLmk.center.zMean = (SimLmk.lims.zMax + SimLmk.lims.zMin)/2;
