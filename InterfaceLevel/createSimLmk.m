function SimLmk = createSimLmk(World)

% CREATESIMLMK  Create a set of landmarks for simulation.
%   SIMLMK = CREATESIMLMK(World) creates the simulation structure SIMLMK
%   from information contained in the user-defined World structure. See
%   userData.m for the specification of this input structure.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if isempty(World.points)
    World.points = zeros(3,0);
end
if isempty(World.segments)
    World.segments = zeros(6,0);
end

PN = size(World.points,2); % number of points in the simulated world
SN = size(World.segments,2); % number of segments

SimLmk.points.id      = (1:PN);
SimLmk.points.coord   = World.points;
SimLmk.segments.id    = PN+(1:SN); 
SimLmk.segments.coord = World.segments;









