function [rp,RPq,RPp] = Rp(q,p)

% RP  Rotation matrix (from quaternion) times vector.
%   RP(Q,P) evaluates the product
%
%       q2R(Q)*P
%
%   where Q is a quaternion and P is a 3D point or a matrix of 3D points. A
%   matrix of 3D points is defined P = [P1 ... Pn] with each Pi =
%   [xi;yi;zi].
%
%   [rp,RPq,RPp] = RP(Q,P) returns Jacobians wrt Q and P. Note that this
%   only works with single points P = [x;y;z].
%
%   See also RTP, Q2R.

R  = q2R(q);
rp = R*p;

if nargout > 1 % we want Jacobians

    if size(p,2) == 1

        [a,b,c,d] = split(q);
        [x,y,z]   = split(p);

        axdycz = 2*(a*x - d*y + c*z);
        bxcydz = 2*(b*x + c*y + d*z);
        cxbyaz = 2*(c*x - b*y - a*z);
        dxaybz = 2*(d*x + a*y - b*z);

        RPq = [...
            [  axdycz,  bxcydz, -cxbyaz, -dxaybz]
            [  dxaybz,  cxbyaz,  bxcydz,  axdycz]
            [ -cxbyaz,  dxaybz, -axdycz,  bxcydz]];

        RPp = R;
        
    else
        error('Jacobians only available for single points')
    end
end


return


%% BUILD AND TEST JACOBIANS

syms a b c d x y z real

q = [a;b;c;d];
p = [x;y;z];

[rp,RPq,RPp] = Rp(q,p);

RPq1 = simple(jacobian(rp,q));
RPp1 = simple(jacobian(rp,p));

ERPq = simplify(RPq-RPq1)
ERPp = simplify(RPp-RPp1)


