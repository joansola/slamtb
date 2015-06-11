function [Frm] = createFrames(Rob, Opt)

% CREATEFRAMES  Create Frm structure array.
%   Frm = CREATEFRAMES(Frame) creates the structure array Frm() to be
%   used as SLAM data. The input Frame{}  is a cell array of structures
%   as specified by the user in userData.m. There must be one Frame{}
%   per each frame type considered. See userData.m for details.
%
%   State and manifold data allocations are fixed for each position in the
%   window. Range information for the storage of this data is defined here
%   and should never be modified.

%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.

stateSize = Rob.state.size;
maniSize = Rob.manifold.size;

for frm = 1:Opt.map.numFrames

    Frm(frm).frm = frm;
    Frm(frm).id = [];
    Frm(frm).used = false;
    Frm(frm).rob = [];
    Frm(frm).state.x = [];
    Frm(frm).state.r = (1 + (frm-1)*stateSize : frm*stateSize);
    Frm(frm).state.size = stateSize;
    
    Frm(frm).manifold.x = [];
    Frm(frm).manifold.active = false;
    Frm(frm).manifold.r = (1 + (frm-1)*maniSize : frm*maniSize);
    Frm(frm).manifold.size = maniSize;
    
end

