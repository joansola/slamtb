function v = e2v(e)

% E2V Euler angles to rotation vector conversion

R = e2R(e);
v = rodrigues(R);

