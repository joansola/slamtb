function [it,ITt,ITe] = te2it(t,e)

% TE2IT  Get translation vector of inverse transformation
%   IT = TE2IT(T,E) computes the translation vector corresponding to the
%   transformation inverse to (T,E), i.e.:
%
%       IT = -R'*T
%
%   where R = e2R(E)

Rt = e2R(e)';

it = -Rt*t;

if nargout > 1

    [a,b,c] = deal(e(1),e(2),e(3));
    [x,y,z] = deal(t(1),t(2),t(3));


    sa = sin(a);
    sb = sin(b);
    sc = sin(c);
    ca = cos(a);
    cb = cos(b);
    cc = cos(c);

    ITt = [...
        [          -cb*cc,          -cb*sc,      sb]
        [  ca*sc-sa*sb*cc, -ca*cc-sa*sb*sc,  -sa*cb]
        [ -sa*sc-ca*sb*cc,  sa*cc-ca*sb*sc,  -ca*cb]];
    ITe = [...
        [                                              0,       sb*cc*x+sb*sc*y+cb*z,                         cb*(sc*x-cc*y)]
        [ -x*sa*sc-x*ca*sb*cc+y*sa*cc-y*ca*sb*sc-ca*cb*z, -sa*(cb*cc*x+cb*sc*y-sb*z),  x*ca*cc+x*sa*sb*sc+y*ca*sc-y*sa*sb*cc]
        [ -x*ca*sc+x*sa*sb*cc+y*ca*cc+y*sa*sb*sc+sa*cb*z, -ca*(cb*cc*x+cb*sc*y-sb*z), -x*sa*cc+x*ca*sb*sc-y*sa*sc-y*ca*sb*cc]];

end


return

%%

syms a b c x y z real

t = [x;y;z];
e = [a;b;c];

[it,ITt,ITe] = te2it(t,e)

ITt1 = jacobian(it,t)
ITe1 = jacobian(it,e)

simplify(ITt - ITt1)
simplify(ITe - ITe1)
