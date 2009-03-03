function  dispEstRob = displayRobot(dispEstRob,dispEstElli,Rob,ns)

global Map

[te,Re,Ret] = getTR(Rob);
Te = repmat(te,1,size(Rob.graphics.vert,1));
Rob.graphics.vert = Rob.graphics.vert0*Ret+Te';
set(dispEstRob,'vertices',Rob.graphics.vert);

Pe = Map.P(Rob.r(1:3),Rob.r(1:3));
[ellix,elliy,elliz] = cov3elli(te,Pe,ns,16);
set(dispEstElli,...
    'xdata',ellix,...
    'ydata',elliy,...
    'zdata',elliz)

