function ao = normAngle(ai)

% NORMANGLE Normalize angle to (-pi .. pi] values

ao = ai;
while any(ao <= -pi)
    ao(ao <= -pi) = ao(ao <= -pi) + 2*pi;
end
while any(ao > pi)
    ao(ao > pi) = ao(ao > pi) - 2*pi;
end
