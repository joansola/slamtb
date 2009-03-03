function [rtp,ETPe,ETPp] = Etp(e,p)

% ETP  Transposed rotation matrix from Euler angles times vector
%   [rtp,ETPe,ETPp] = ETP(e,p) evaluates the product
%
%       rtp = e2R(e)'*p
%
%   and returns the result and Jacobians wrt e and p.
%
%   See also RP, Q2R.

Et  = e2R(e)'; % Transposed rotation matrix
rtp = Et*p;

if nargout > 1 % we want Jacobians

    [a,b,c] = deal(e(1),e(2),e(3));
    [x,y,z] = deal(p(1),p(2),p(3));


    sa = sin(a);
    sb = sin(b);
    sc = sin(c);
    ca = cos(a);
    cb = cos(b);
    cc = cos(c);

    ETPe = [...
        [                                             0,      -sb*cc*x-sb*sc*y-cb*z,                         -cb*(x*sc-y*cc)]
        [ x*sa*sc+x*ca*sb*cc-y*sa*cc+y*ca*sb*sc+ca*cb*z,  sa*(cb*cc*x+cb*sc*y-sb*z),  -x*ca*cc-x*sa*sb*sc-y*ca*sc+y*sa*sb*cc]
        [ x*ca*sc-x*sa*sb*cc-y*ca*cc-y*sa*sb*sc-sa*cb*z,  ca*(cb*cc*x+cb*sc*y-sb*z),   x*sa*cc-x*ca*sb*sc+y*sa*sc+y*ca*sb*cc]];

    ETPp = Et;

end


return


%% build and test jacobians

syms a b c x y z real

e = [a;b;c];
p = [x;y;z];

[rtp,ETPe,ETPp] = Etp(e,p);

ETPe1 = simple(jacobian(rtp,e))
ETPp1 = simple(jacobian(rtp,p))

ETEPe = simplify(ETPe-ETPe1)
ETEPp = simplify(ETPp-ETPp1)

