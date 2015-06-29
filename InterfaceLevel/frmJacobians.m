function [Rob,Frm] = frmJacobians(Rob,Frm)

% FRMJACOBIANS Compute Jacobians for projection onto the manifold.

for rob = [Rob.rob]
    for frm = [Frm(rob,[Frm(rob,:).used]).frm]
        q = Frm(rob,frm).state.x(4:7);
        Frm(rob,frm).state.M = [eye(3), zeros(3,3) ; zeros(4,3) q2Pi(q)];
    end
end
