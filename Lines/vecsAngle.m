function a = vecsAngle(u,v)

% VECSANGLE  Angle between two vectors.

a = acos(dot(u,v)/sqrt(dot(u,u)*dot(v,v)));
if a > pi/2
    a = pi-a;
end

