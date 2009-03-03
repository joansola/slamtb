function [Xo,Jx,Ju] = reframe(X,u)

n = size(u,1)/2;

r = X(1:n);
v = X(n+1:2*n);

dr = u(1:n);
de = u(n+1:2*n);

R = e2R(de);

ro = R'*(r-dr);
vo = R'*v;

Xo = [ro;vo];


if nargout > 1
    % Jacobians

    Rt = R';
    Z3 = zeros(3);

    Jx = [Rt Z3;Z3 Rt];

    if nargout > 2

        x  = X(1);
        y  = X(2);
        z  = X(3);
        vx = X(4);
        vy = X(5);
        vz = X(6);

        dx = u(1);
        dy = u(2);
        dz = u(3);
        a  = u(4);
        b  = u(5);
        c  = u(6);

        sa = sin(a);
        ca = cos(a);
        sb = sin(b);
        cb = cos(b);
        sc = sin(c);
        cc = cos(c);


        Rde = [
            [                                                             0,         -sb*cc*(x-dx)-sb*sc*(y-dy)-cb*(z-dz),                        -cb*sc*(x-dx)+cb*cc*(y-dy)]
            [ (sa*sc+ca*sb*cc)*(x-dx)+(-sa*cc+ca*sb*sc)*(y-dy)+ca*cb*(z-dz), sa*cb*cc*(x-dx)+sa*cb*sc*(y-dy)-sa*sb*(z-dz), (-ca*cc-sa*sb*sc)*(x-dx)+(-ca*sc+sa*sb*cc)*(y-dy)]
            [ (ca*sc-sa*sb*cc)*(x-dx)+(-ca*cc-sa*sb*sc)*(y-dy)-sa*cb*(z-dz), ca*cb*cc*(x-dx)+ca*cb*sc*(y-dy)-ca*sb*(z-dz),   (sa*cc-ca*sb*sc)*(x-dx)+(sa*sc+ca*sb*cc)*(y-dy)]
            ];

        Vde = [
            [                                                  0,     -sb*cc*vx-sb*sc*vy-cb*vz,                          -cb*(sc*vx-cc*vy)]
            [ vx*sa*sc+vx*ca*sb*cc-vy*sa*cc+vy*ca*sb*sc+ca*cb*vz, sa*(cb*cc*vx+cb*sc*vy-sb*vz), -vx*ca*cc-vx*sa*sb*sc-vy*ca*sc+vy*sa*sb*cc]
            [ vx*ca*sc-vx*sa*sb*cc-vy*ca*cc-vy*sa*sb*sc-sa*cb*vz, ca*(cb*cc*vx+cb*sc*vy-sb*vz),  vx*sa*cc-vx*ca*sb*sc+vy*sa*sc+vy*ca*sb*cc]
            ];


        Ju = [-Rt Rde;Z3 Vde];
        
    end
end