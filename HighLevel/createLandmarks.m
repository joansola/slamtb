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

        Lo.x = [];
        Lo.p = [];
        
        Lo.sig = [];
        
        Lo.nsearch = 0;
        Lo.nmatch  = 0;
        Lo.ninlier = 0;

        % Non observable priors
        if isfield(Li,'nonObsMean')
            Lo.n = Li.nonObsMean;
            Lo.N = diag(Li.nonObsStd.^2);
        else
            Lo.n = [];
            Lo.N = [];
        end
        
        switch Li.type
            case {'eucPnt'}
                Lo.size = 3;
            case {'homPnt'}
                Lo.size = 4;
            case {'idpPnt','plkLin'}
                Lo.size = 6;
        end

        Lmk(id) = Lo;
        
    end
    
end

