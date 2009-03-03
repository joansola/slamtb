function JqE = q2erdfJac(q)

a = q(1);
b = q(2);
c = q(3);
d = q(4);

admbc = (a^2+d^2-b^2-c^2-1);
t1 = 2/(-admbc*(1+admbc))^(1/2);

JqE = [
    [ -d/(a^2+d^2),  c/(c^2+b^2), -b/(c^2+b^2),  a/(a^2+d^2)]
    [        -a*t1,         b*t1,         c*t1,        -d*t1]
    [ -d/(a^2+d^2), -c/(c^2+b^2),  b/(c^2+b^2),  a/(a^2+d^2)]
];
