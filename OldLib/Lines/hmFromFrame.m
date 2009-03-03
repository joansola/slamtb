function [hm,HMf,HMh] = hmFromFrame(F,hmf)

H = [F.R F.t;0 0 0 1];

hm = H*hmf;

if nargout > 1

    x = t(1);
    y = t(2);
    z = t(3);
    X = hmf(1);
    Y = hmf(2);
    Z = hmf(3);
    W = hmf(4);
    a = F.q(1);
    b = F.q(2);
    c = F.q(3);
    d = F.q(4);

    s1 = 2*a*X+2*d*Y-2*c*Z-2*W*a*x-2*W*d*y+2*W*c*z;
    s2 = 2*b*X+2*c*Y+2*d*Z-2*W*b*x-2*W*c*y-2*W*d*z;
    s3 = 2*c*X-2*b*Y+2*a*Z-2*W*c*x+2*W*b*y-2*W*a*z;
    s4 = 2*d*X-2*a*Y-2*b*Z-2*W*d*x+2*W*a*y+2*W*b*z;
    
    HMFt = [W*eye(3);0 0 0];
    HMFq = [...
        [  s1,  s2, -s3, -s4]
        [ -s4,  s3,  s2, -s1]
        [  s3,  s4,  s1,  s2]
        [   0,   0,   0,   0]];
    HMFf = [HMFt HMFq];
    HMFh = H;

end


return

%%

syms a b c d x y z X Y Z W real
t = [x;y;z];
q = [a;b;c;d];
F.X=[x;y;z;a;b;c;d];
F = updateFrame(F);
hmf=[X;Y;Z;W];

hm = hmFromFrame(F,hmf);

HMt = simplify(jacobian(hm,t))
HMq = simplify(jacobian(hm,q))

HMh = simplify(jacobian(hm,hmf))
