function Jr = rightExpMapJac(w)
W = hat(w);
theta2 = w'*w;
theta = sqrt(theta2);
m1 = (1 - cos(theta)) / theta2 * W;
m2 = (theta - sin(theta)) / (theta2 * theta) * (W * W);
Jr = eye(3) - m1 + m2;
end
