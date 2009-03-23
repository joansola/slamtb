function Obs = createObservations(Sen,Lmk)

% CREATEOBSERVATIONS Create Obs structure array.
%   Rob = CREATEOBSERVATIONS(Sen,Lmk) creates the Obs() structure array to
%   be used as SLAM data, from the information contained in Sen() and
%   Rob(). See the toolbox documentation for details on this structure.


for sen = 1:numel(Sen)
    
    for lmk = 1:numel(Lmk)
        
        S = Sen(sen);
        L = Lmk(lmk);
        
        O.sen     = sen;        % sensor index
        O.lmk     = lmk;        % landmark index.
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
        O.measured= false;      % lmk has been measured?
        O.matched = false;      % lmk has been matched?
        O.updated = false;      % lmk has been updated?
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
