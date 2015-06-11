function Fac = createFactors(Opt)

% CREATEFACTORS  Create Fac structure array.
%   Fac = CREATEFACTORS(Factor) creates the structure array Fac() to be
%   used as SLAM data. The input Factor{}  is a cell array of structures
%   as specified by the user in userData.m. There must be one Factor{}
%   per each factor type considered. See userData.m for details.

%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.

% Compute max nbr of factors based on general options
Opt.map.numFactors = Opt.map.numFrames*(Opt.correct.nUpdates + Opt.init.nbrInits(2)) + Opt.init.nbrInits(1);

% Create all factor structures
for fac = 1:Opt.map.numFactors

    Fac(fac).used = false; % Factor is being used ?
    Fac(fac).fac = fac; % index in Fac array
    Fac(fac).id = []; % Factor unique ID
    Fac(fac).type = ''; % {'motion','measurement','absolute'}
    Fac(fac).frmId = []; % frame ids
    Fac(fac).sen = []; % sen index
    Fac(fac).lmk = []; % lmk index
    Fac(fac).id1 = []; % id of block 1
    Fac(fac).id2 = []; % id of block 2
    Fac(fac).meas.y = [];
    Fac(fac).meas.R = [];
    Fac(fac).meas.W = []; % measurement information matrix
    Fac(fac).exp.e = []; % expectation
    Fac(fac).exp.E = []; % expectation cov
    Fac(fac).exp.W = []; % expectation information matrix
    Fac(fac).err.z = []; % error or innovation (we call it error because we are on graph SLAM)
    Fac(fac).err.Z = []; % error cov matrix
    Fac(fac).err.W  = []; % error information matrix
    Fac(fac).err.E_node1 = []; % Jac. of error wrt. node 1
    Fac(fac).err.E_node2 = []; % Jac. of error wrt. node 2
    
end

