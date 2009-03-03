function q = euler2quat(e)

% EULER2QUAT  Euler angles to quaternion conversion

r2 = e(1)/2;
p2 = e(2)/2;
y2 = e(3)/2;

q = [
  cos(y2)*cos(p2)*cos(r2)+sin(y2)*sin(p2)*sin(r2)
  cos(y2)*cos(p2)*sin(r2)-sin(y2)*sin(p2)*cos(r2)
  cos(y2)*sin(p2)*cos(r2)+sin(y2)*cos(p2)*sin(r2)
 -cos(y2)*sin(p2)*sin(r2)+sin(y2)*cos(p2)*cos(r2)
];
