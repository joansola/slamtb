function Obs = createObservations(Sen,Lmk)

% CREATEOBSERVATIONS Create Obs structure array.
%   Rob = CREATEOBSERVATIONS(Sen,Lmk) creates the Obs() structure array to
%   be used as SLAM data, from the information contained in Sen() and
%   Rob(). See the toolbox documentation for details on this structure.


for sen = 1:numel(Sen)
    
    for lmk = 1:numel(Lmk)
        
        S = Sen(sen);
        L = Lmk(lmk);
        
        O.sen       = sen;        % sensor index
        O.lmk       = lmk;        % landmark index.
        O.sid       = S.id;       % sensor id
        O.lid       = L.id;       % lmk id
        O.meas.y    = [];         % observation
        O.meas.R    = [];         % observation cov
        O.nom.n     = [];         % expected non-observable
        O.nom.N     = [];         % expected non-observable cov
        O.exp.e     = [];         % expectation mean
        O.exp.E     = [];         % expectation cov
        O.inn.z     = [];         % innovation
        O.inn.Z     = [];         % innovation cov
        O.inn.iZ    = [];         % inverse inn. cov
        O.inn.MD2   = 0;          % Mahalanobis distance squared
        O.app.pred  = [];         % predicted appearence
        O.app.curr  = [];         % current appearence
        O.app.sc    = 0;          % match score
        O.vis       = false;      % lmk is visible?
        O.measured  = false;      % lmk has been measured?
        O.matched   = false;      % lmk has been matched?
        O.updated   = false;      % lmk has been updated?
        O.Jac.E_r   = [];         % Jac wrt robot state - Obs function
        O.Jac.E_s   = [];         % Jac wrt sensor
        O.Jac.E_l   = [];         % Jac wrt landmark
        
        Obs(sen,lmk) = O;
        
    end
end
