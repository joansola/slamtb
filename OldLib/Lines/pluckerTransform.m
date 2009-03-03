function [H,Hf,Hq] = pluckerTransform(F,q)

if nargin == 1
    t = F(1:3);
    q = F(4:7);
else
    t = F;
end


R = q2R(q);

txR = hat(t)*R;

H = [R txR;zeros(3) R];

if nargout > 1

    [a,b,c,d] = split(q);
    [x,y,z]   = split(t);


    Ht = [...
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,      2*b*d-2*a*c,     -2*b*c-2*a*d]
        [     -2*b*d+2*a*c,                0,  a^2+b^2-c^2-d^2]
        [      2*b*c+2*a*d, -a^2-b^2+c^2+d^2,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,      2*c*d+2*a*b, -a^2+b^2-c^2+d^2]
        [     -2*c*d-2*a*b,                0,      2*b*c-2*a*d]
        [  a^2-b^2+c^2-d^2,     -2*b*c+2*a*d,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,  a^2-b^2-c^2+d^2,     -2*c*d+2*a*b]
        [ -a^2+b^2+c^2-d^2,                0,      2*b*d+2*a*c]
        [      2*c*d-2*a*b,     -2*b*d-2*a*c,                0]
        [                0,                0,                0]
        [                0,                0,                0]
        [                0,                0,                0]];
    Hq = [...
        [          2*a,          2*b,         -2*c,         -2*d]
        [          2*d,          2*c,          2*b,          2*a]
        [         -2*c,          2*d,         -2*a,          2*b]
        [            0,            0,            0,            0]
        [            0,            0,            0,            0]
        [            0,            0,            0,            0]
        [         -2*d,          2*c,          2*b,         -2*a]
        [          2*a,         -2*b,          2*c,         -2*d]
        [          2*b,          2*a,          2*d,          2*c]
        [            0,            0,            0,            0]
        [            0,            0,            0,            0]
        [            0,            0,            0,            0]
        [          2*c,          2*d,          2*a,          2*b]
        [         -2*b,         -2*a,          2*d,          2*c]
        [          2*a,         -2*b,         -2*c,          2*d]
        [            0,            0,            0,            0]
        [            0,            0,            0,            0]
        [            0,            0,            0,            0]
        [ -2*z*d-2*y*c, -2*z*c+2*y*d, -2*z*b-2*y*a, -2*z*a+2*y*b]
        [  2*z*a+2*x*c,  2*z*b-2*x*d, -2*z*c+2*x*a, -2*z*d-2*x*b]
        [ -2*y*a+2*x*d, -2*y*b+2*x*c,  2*y*c+2*x*b,  2*y*d+2*x*a]
        [          2*a,          2*b,         -2*c,         -2*d]
        [          2*d,          2*c,          2*b,          2*a]
        [         -2*c,          2*d,         -2*a,          2*b]
        [ -2*z*a+2*y*b,  2*z*b+2*y*a, -2*z*c+2*y*d,  2*z*d+2*y*c]
        [ -2*z*d-2*x*b,  2*z*c-2*x*a,  2*z*b-2*x*d, -2*z*a-2*x*c]
        [  2*y*d+2*x*a, -2*y*c-2*x*b, -2*y*b+2*x*c,  2*y*a-2*x*d]
        [         -2*d,          2*c,          2*b,         -2*a]
        [          2*a,         -2*b,          2*c,         -2*d]
        [          2*b,          2*a,          2*d,          2*c]
        [  2*z*b+2*y*a,  2*z*a-2*y*b, -2*z*d-2*y*c, -2*z*c+2*y*d]
        [  2*z*c-2*x*a,  2*z*d+2*x*b,  2*z*a+2*x*c,  2*z*b-2*x*d]
        [ -2*y*c-2*x*b, -2*y*d-2*x*a, -2*y*a+2*x*d, -2*y*b+2*x*c]
        [          2*c,          2*d,          2*a,          2*b]
        [         -2*b,         -2*a,          2*d,          2*c]
        [          2*a,         -2*b,         -2*c,          2*d]];
    
    if nargin == 1
        Hf = [Ht Hq];
    else
        Hf = Ht;
    end


end

return

%% jac

syms a b c d x y z real
q = [a;b;c;d];
t = [x;y;z];

H = pluckerTransform(t,q);

Ht = (jacobian(H,t))

Hq = (jacobian(H,q))

%%
HH = [Ht Hq];

[HH,S] = subexpr(HH,'S');

S
Ht = HH(:,1:3)
Hq = HH(:,4:7)
