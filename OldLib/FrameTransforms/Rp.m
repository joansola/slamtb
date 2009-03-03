function [rp,RPq,RPp] = Rp(q,p)

% RP  Rotation matrix (from quaternion) times vector
%   [rp,RPq,RPp] = RP(q,p) evaluates the product
%
%       rp = q2R(q)*p
%
%   and returns the result and Jacobians wrt q and p.
%
%   See also RTP, Q2R.

R  = q2R(q);
rp = R*p;

if nargout > 1 % we want Jacobians
   
    [a,b,c,d] = split(q);
    [x,y,z]   = split(p);
    
    axdycz = 2*(a*x-d*y+c*z);
    bxcydz = 2*(b*x+c*y+d*z);
    cxbyaz = 2*(c*x-b*y-a*z);
    dxaybz = 2*(d*x+a*y-b*z);
    
    RPq = [...
        [  axdycz,  bxcydz, -cxbyaz, -dxaybz]
        [  dxaybz,  cxbyaz,  bxcydz,  axdycz]
        [ -cxbyaz,  dxaybz, -axdycz,  bxcydz]];
    
    RPp = R;
    
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


