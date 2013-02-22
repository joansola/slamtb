function ao = normAngle(ai,deg)

% NORMANGLE Normalize angle to (-pi .. pi] values.
%   NORMANGLE(A) brings angle A to the range (-pi .. pi] by adding an
%   integer number of turns.
%   
%   NORMANGLE(A,DEG) with DEG ~= false, uses degrees instead of radians,
%   and thus the angle A is normalized to the range (-180 .. 180].

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 2
    deg = false;
end

if deg
    halfTurn = 180;
else
    halfTurn = pi;
end

ao = ai;
while any(ao <= -halfTurn)
    ao(ao <= -halfTurn) = ao(ao <= -halfTurn) + 2*halfTurn;
end
while any(ao > halfTurn)
    ao(ao > halfTurn) = ao(ao > halfTurn) - 2*halfTurn;
end









