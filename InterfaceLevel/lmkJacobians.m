function Lmk = lmkJacobians(Lmk)

% LMKJACOBIANS Compute Jacobians for projection onto the manifold.
%   LMKJACOBIANS computes all the Jacobians of the landmarks in structure
%   array Lmk for the projection of the landmark errors into the landmark
%   manifolds. The computed Jacobians are stored in Lmk.state.M. Its
%   expression depends on the landmark type.
%
%   Landmark types are specifyed by Lmk.type. In the case of Euclidean
%   points 'eucPnt', details follow.
%
%   The landmark's position manifold is defined trivially, so that
%       dp = [dpx dpy dpz]'
%   and the composition is just a sum,
%       p+ = p + dp.
%   In such case, the Jacobian 
%       M = d p+ / d dp 
%   is the identity matrix. To save some computations, this function
%   returns just M = 1 (scalar 'one').
%
%   For details on the Jacobians of other landmark parametrizations, please
%   refer to the code by editing the file lmkJacobians.m.
%
%   See also FRMJACOBIANS.

% Copyright 2015 Joan Sola @ IRI-UPC-CSIC.

for lmk = [Lmk([Lmk.used]).lmk]
    switch Lmk(lmk).type
        case 'eucPnt'
            Lmk(lmk).state.M = 1; % trivial Jac
        case 'hmgPnt'
            [~,~,H_dh] = composeHmgPnt(Lmk(lmk).state.x, zeros(3,1));
            Lmk(lmk).state.M = H_dh;
        otherwise
            error('??? Unknown landmark type ''%s'' or Jacobian not implemented.',Lmk.type)
    end
end
