function dispElli = drawElliRobot(dispElli, Rob, ns, NP)

global Map

if nargin < 4
    NP = 16;
end

r = Rob.r(1:3);
R = Map.X(r);
P = Map.P(r,r);

[x,y,z] = cov3elli(R,P,ns,NP);

set(dispElli,...
    'xdata',x,...
    'ydata',y,...
    'zdata',z);

end
