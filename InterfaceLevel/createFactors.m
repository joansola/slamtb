function Fac = createFactors(Opt)

% CREATEFACTORS  Create Fac structure array.
%   Fac = CREATEFACTORS(Factor) creates the structure array Fac() to be
%   used as SLAM data. The input Factor{}  is a cell array of structures
%   as specified by the user in userData.m. There must be one Factor{}
%   per each factor type considered. See userData.m for details.

%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.

for fac = 1:Opt.map.numFactors

    Fac(fac).fac = fac;
    Fac(fac).id = [];
    Fac(fac).used = false;
    Fac(fac).type = ''; % {'motion','measurement','absolute'}
    Fac(fac).frameIds = []; % frame ids
    Fac(fac).sen = []; % sen index
    Fac(fac).lmk = []; % lmk index
    Fac(fac).e = []; % error
    Fac(fac).E = []; % cov matrix
    Fac(fac).W = []; % information matrix
    Fac(fac).J1 = []; % Jac. wrt. node 1
    Fac(fac).J2 = []; % Jac. wrt. node 2
    
end