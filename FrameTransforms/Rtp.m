function [rtp,RTPq,RTPp] = Rtp(q,p)

% RTP  Transposed rotation matrix from quaternion, times vector.
%   [rtp,RTPq,RTPp] = RTP(q,p) evaluates the product
%
%       rtp = q2R(q)'*p
%
%   and returns the result and Jacobians wrt q and p.
%
%   See also RP, Q2R.

Rt  = q2R(q)'; % Transposed rotation matrix
rtp = Rt*p;

if nargout > 1 % we want Jacobians
    
    [a,b,c,d] = split(q);
    [x,y,z]   = split(p);
    
    axdycz = 2*(a*x+d*y-c*z);
    bxcydz = 2*(b*x+c*y+d*z);
    cxbyaz = 2*(c*x-b*y+a*z);
    dxaybz = 2*(d*x-a*y-b*z);
    
    RTPq = [...
        [  axdycz,  bxcydz, -cxbyaz, -dxaybz]
        [ -dxaybz,  cxbyaz,  bxcydz, -axdycz]
        [  cxbyaz,  dxaybz,  axdycz,  bxcydz]];

    RTPp = Rt;
    
end


return


%% build and test jacobians

syms a b c d x y z real

q = [a;b;c;d];
p = [x;y;z];

[rtp,RTPq,RTPp] = Rtp(q,p);

RTPq1 = simple(jacobian(rtp,q));
RTPp1 = simple(jacobian(rtp,p));

ETRPq = simplify(RTPq-RTPq1)
ETRPp = simplify(RTPp-RTPp1)

