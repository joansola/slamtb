function Obs = createObservations(Sen,Lmk)

for sen = 1:numel(Sen)
    
    for lmk = 1:numel(Lmk)
        
        S = Sen(sen);
        L = Lmk(lmk);
        
        O.rid     = S.robot;    % robot id
        O.sid     = S.id;       % sensor id
        O.lid     = L.id;       % lmk id
        O.exp.e   = [];         % expectation mean
        O.exp.E   = [];         % expectation cov
        O.nob.n   = [];         % expected non-observable
        O.nob.N   = [];         % expected non-observable cov
        O.meas.y  = [];         % observation
        O.meas.R  = [];         % observation cov
        O.inn.z   = [];         % innovation
        O.inn.Z   = [];         % innovation cov
        O.inn.iZ  = [];         % inverse inn. cov
        O.inn.MD2 = 0;          % Mahalanobis distance squared
        O.pApp    = [];         % predicted appearence
        O.cApp    = [];         % current appearence
        O.sc      = 0;          % match score
        O.vis     = false;      % lmk is visible?
        O.match   = false;      % lmk is matched?
        O.inlier  = false;      % lmk is consistent?
        O.H_r     = [];         % Jac wrt robot state - Obs function
        O.H_s     = [];         % Jac wrt sensor
        O.H_l     = [];         % Jac wrt landmark
        O.G_r     = [];         % Jac wrt robot - Inv. obs. function
        O.G_s     = [];         % Jac wrt sensor
        O.G_o     = [];         % Jac wrt observation
        O.G_n     = [];         % Jac wrt non-observable        
        
        Obs(sen,lmk) = O;
        
    end
end
