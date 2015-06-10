function [Frm,Fac] = createGraphStructures(Opt)

% CREATESLAMSTRUCTURES  Initialize SLAM data structures from user data.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

for frm = 1:Opt.graph.numFrames
    Frm(frm).frm = frm;
    Frm(frm).id = [];
    Frm(frm).state.r = []; % nominal state range
    Frm(frm).error.r = []; % error state range
    Frm(frm).factors = []; % list of connected factors, by factor id.
end

for fac = 1:Opt.graph.numFactors
    Fac(fac).fac = fac;
    Fac(fac).id = [];
    Fac(fac).type = []; % {'motion','measurement','absolute'}
    Fac(fac).frames = []; % list of connected frames (2 for 'motion' types, 1 for 'absolute' types)
    Fac(fac).sen = []; % concerned sensor (for 'measurement' types)
    Fac(fac).lmk = []; % concerned landmark (for 'measurement types)
end

