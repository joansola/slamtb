function Jlinv = leftLogMapJac(w)
theta2 = w'*w;
theta = sqrt(theta2);
W = hat(w);
m1 = (1 / theta2 - (1 + cos(theta)) / (2 * theta * sin(theta))) * (W * W);
Jlinv = eye(3) - 0.5 * W + m1;
end

