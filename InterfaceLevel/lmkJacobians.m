function Lmk = lmkJacobians(Lmk)

% COMPUTESTATEJACOBIANS Compute Jacobians for projection onto the manifold.

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
