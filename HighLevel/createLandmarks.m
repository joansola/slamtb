function Lmk = createLandmarks(Landmark)

id = 0;

for lmkClass = 1:numel(Landmark)

    numLmk = 0;

    while numLmk < Landmark{lmkClass}.maxNbr

        numLmk = numLmk + 1;
        id = id + 1;
        
        Li = Landmark{lmkClass};
        
        Lo.id   = id;
        Lo.type = Li.type;

        % state
        Lo.state.x = [];
        switch Li.type
            case {'eucPnt'}
                Lo.state.size = 3;
            case {'homPnt'}
                Lo.state.size = 4;
            case {'idpPnt','plkLin'}
                Lo.state.size = 6;
        end

        % other parameters
        Lo.par = [];
        
        Lo.sig = [];
        
        Lo.nsearch = 0;
        Lo.nmatch  = 0;
        Lo.ninlier = 0;

        % Non observable priors
        if isfield(Li,'nonObsMean')
            Lo.nob.n = Li.nonObsMean;
            Lo.nob.N = diag(Li.nonObsStd.^2);
        else
            Lo.nob.n = [];
            Lo.nob.N = [];
        end
        
        Lmk(id) = Lo;
        
    end
    
end

