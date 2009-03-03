function [it,ITt,ITq] = t2it(t,q)

% T2IT  Get translation vector of inverse transformation
%   IT = T2IT(T,Q) computes the translation vector corresponding to the
%   transformation inverse to (T,Q), i.e.:
%
%       IT = -R'*T
%
%   where R = q2R(Q)

Rt = q2R(q)';

it = -Rt*t;

if nargout > 1

    [a,b,c,d] = deal(q(1),q(2),q(3),q(4));
    [x,y,z] = deal(t(1),t(2),t(3));


    ITt = [...
        [ -a^2-b^2+c^2+d^2,     -2*b*c-2*a*d,     -2*b*d+2*a*c]
        [     -2*b*c+2*a*d, -a^2+b^2-c^2+d^2,     -2*c*d-2*a*b]
        [     -2*b*d-2*a*c,     -2*c*d+2*a*b, -a^2+b^2+c^2-d^2]];
    ITq = [...
        [ -2*a*x-2*d*y+2*c*z, -2*b*x-2*c*y-2*d*z,  2*c*x-2*b*y+2*a*z,  2*d*x-2*a*y-2*b*z]
        [  2*d*x-2*a*y-2*b*z, -2*c*x+2*b*y-2*a*z, -2*b*x-2*c*y-2*d*z,  2*a*x+2*d*y-2*c*z]
        [ -2*c*x+2*b*y-2*a*z, -2*d*x+2*a*y+2*b*z, -2*a*x-2*d*y+2*c*z, -2*b*x-2*c*y-2*d*z]];

end


return

%%

syms a b c d x y z real

t = [x;y;z];
q = [a;b;c;d];

it = t2it(t,q)

ITt = jacobian(it,t)
ITq = jacobian(it,q)
