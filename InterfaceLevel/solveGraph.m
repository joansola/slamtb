function [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraph(Rob,Sen,Lmk,Obs,Frm,Fac,Opt)

% Take algorithms from courseSLAM.pdf

switch Opt.map.solver
    case 'QR'
        error('??? Graph solver ''%s'' not implemented. Try ''Cholesky''.', Opt.map.solver)
        % [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphQR(Rob,Sen,Lmk,Obs,Frm,Fac);
    case 'Cholesky'
        [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphCholesky(Rob,Sen,Lmk,Obs,Frm,Fac);
    case 'Schur'
        error('??? Graph solver ''%s'' not implemented. Try ''Cholesky''.', Opt.map.solver)
        % [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphSchur(Rob,Sen,Lmk,Obs,Frm,Fac);
    otherwise
        error('??? Unknown graph solver ''%s''.', Opt.map.solver)
end

