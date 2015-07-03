function Frm = frmJacobians(Frm)

% FRMJACOBIANS Compute Jacobians for projection onto the manifold.
%   FRMJACOBIANS computes all the Jacobians of the frames in structure
%   array Frm for the projection of the frame errors into the frame
%   manifolds. The computed Jacobians are stored in Frm.state.M. 
%
%   Frames are [p,q]'. Details follow.
%
%   The position manifold is defined trivially, so that
%       dp = [dpx dpy dpz]'
%   and the composition is just a sum,
%       p+ = p + dp,
%   so the Jacobian is the 3x3 identity matrix I.
%
%   The quaternion manifold is defined with a tangent space:
%       phi = [phix, phiy, phiz]'
%   so that the quaternion error is expressed
%       dq = [sqrt(1 - norm(phi)^2)]
%            [         phi         ]
%   and the composition is done locally
%       q+ = qProd( 1, dq)
%   In such case, the Jacobian is given by
%       dq+ / d dq = q2Pi(q)
%
%   The total Jacobian is thus
%
%       M = [  I     0    ]
%           [  0  q2Pi(q) ]
%
%   See also LMKJACOBIANS.

% Copyright 2015 Joan Sola @ IRI-UPC-CSIC.


for rob = 1:size(Frm,1)
    for frm = [Frm(rob,[Frm(rob,:).used]).frm]
        q = Frm(rob,frm).state.x(4:7);
        Frm(rob,frm).state.M = [eye(3), zeros(3,3) ; zeros(4,3) q2Pi(q)];
    end
end
