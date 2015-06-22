function [Fac, e, W, J1, J2, r1, r2] = computeError(Rob,Sen,Lmk,Obs,Frm,Fac)

global Map

switch Fac.type
    case 'absolute'
        Fac.exp.e = Frm.state.x;
        [pq, ~, PQ_e] = frameIncrement(Fac.meas.y, Fac.exp.e);
        [Fac.err.z, Z_pq] = qpose2epose(pq);
        Fac.err.E_node1 = Z_pq * PQ_e * Frm.state.M;
        Fac.err.E_node2 = zeros(6,0);
        Fac.state.r1 = Frm.state.r;
        Fac.state.r2 = [];
        
    case 'motion'
        [Fac.exp.e, E_x1, E_x2] = frameIncrement(...
            Map.x(Frm(1).state.r), ...
            Map.x(Frm(2).state.r));
        [pq, ~, PQ_e] = frameIncrement(Fac.meas.y, Fac.exp.e);
        [Fac.err.z, Z_pq] = qpose2epose(pq);
        Fac.err.E_node1 = Z_pq * PQ_e * E_x1 * Frm(1).state.M;
        Fac.err.E_node2 = Z_pq * PQ_e * E_x2 * Frm(2).state.M;
        Fac.state.r1 = Frm(1).state.r;
        Fac.state.r2 = Frm(2).state.r;

    case 'measurement'
        error('??? ''measurement'' NYI.')
    otherwise
        error('??? Unknown factor type ''%s''.', Fac.type)
end

if nargout > 1
    e = Fac.err.z;
    W = Fac.err.W;
    J1 = Fac.err.E_node1;
    J2 = Fac.err.E_node2;
    r1 = Fac.state.r1;
    r2 = Fac.state.r2;
end
