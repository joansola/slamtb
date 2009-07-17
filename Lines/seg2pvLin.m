function [m,M_l] = seg2pvLin(l)

% SEG2PVLIN  Segment to point-vector line transform.
%   SEG2PVLIN(S) transforms the segment S=[P1;P2] to a point-vector line
%   [P1;V], where V is a (non-normalized) director vector of the line.
%
%   [pvl,PVL_ppl] = SEG2PVLIN(S) returns the Jacobian of the
%   transformation.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

m(1:3,1) = l(1:3);
m(4:6,1) = l(4:6)-l(1:3);

if nargout > 1
    
    M_l = [eye(3) zeros(3)
        -eye(3) eye(3)];
end

return

%% jac

syms l1 l2 l3 l4 l5 l6 real
l = [l1;l2;l3;l4;l5;l6];
[m,M_l] = pntsLine2pntVecLine(l);

simplify(M_l - jacobian(m,l))
