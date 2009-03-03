function [ep,EPe,EPp] = Ep(e,p)

% EP  Rotation matrix (from Euler) times vector
%   [ep,EPe,EPp] = EP(e,p) evaluates the product
%
%       ep = e2R(e)*p
%
%   and returns the result and Jacobians wrt e and p.
%
%   See also ETP, RP, RTP, E2R.

E  = e2R(e);
ep = E*p;

if nargout > 1 % we want Jacobians

    [a,b,c]   = deal(e(1),e(2),e(3));
    [x,y,z]   = deal(p(1),p(2),p(3));
    
    sa = sin(a);
    sb = sin(b);
    sc = sin(c);
    ca = cos(a);
    cb = cos(b);
    cc = cos(c);

    EPe = [...
        [ y*sa*sc+y*ca*sb*cc+z*ca*sc-z*sa*sb*cc, cc*(-sb*x+sa*cb*y+ca*cb*z), -cb*sc*x-y*ca*cc-y*sa*sb*sc+z*sa*cc-z*ca*sb*sc]
        [-y*sa*cc+y*ca*sb*sc-z*ca*cc-z*sa*sb*sc, sc*(-sb*x+sa*cb*y+ca*cb*z),  cb*cc*x-y*ca*sc+y*sa*sb*cc+z*sa*sc+z*ca*sb*cc]
        [                        cb*(ca*y-sa*z),      -cb*x-sa*sb*y-ca*sb*z,                                              0]];

    EPp = E;

end


return


%% BUILD AND TEST JACOBIANS

syms a b c x y z real

e = [a;b;c];
p = [x;y;z];

ep = Ep(e,p)

EPe1 = simple(jacobian(ep,e))
EPp1 = simple(jacobian(ep,p))

%%
[ep,EPe,EPp] = Ep(e,p);

EEPe = simplify(EPe-EPe1)
EEPp = simplify(EPp-EPp1)


