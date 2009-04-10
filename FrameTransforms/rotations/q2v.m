function v = q2v(q)

%Q2V Quaternion to rotation vector conversion.

[a,u] = q2au(q);
v = a*u;
