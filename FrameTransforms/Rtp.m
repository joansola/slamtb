function [rtp,RTPq,RTPp] = Rtp(q,p)

% RTP  Transposed rotation matrix (from quaternion) times vector.
%   RTP(Q,P) evaluates the product
%
%       q2R(Q)'*P
%
%   where Q is a quaternion and P is a 3D point or a matrix of 3D points. A
%   matrix of 3D points is defined P = [P1 ... Pn] with each Pi =
%   [xi;yi;zi].
%
%   [rp,RPq,RPp] = RP(Q,P) returns Jacobians wrt Q and P. Note that this
%   only works with single points P = [x;y;z].
%
%   See also RP, Q2R.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

Rt  = q2R(q)'; % Transposed rotation matrix
rtp = Rt*p;

if nargout > 1 % we want Jacobians
    
    [a,b,c,d] = split(q);
    [x,y,z]   = split(p);
    
    axdycz = 2*(a*x + d*y - c*z);
    bxcydz = 2*(b*x + c*y + d*z);
    cxbyaz = 2*(c*x - b*y + a*z);
    dxaybz = 2*(d*x - a*y - b*z);
    
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

