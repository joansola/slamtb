function Frm = createFrames(Opt)

% CREATEFRAMES  Create Frm structure array.
%   Frm = CREATEFRAMES(Frame) creates the structure array Frm() to be
%   used as SLAM data. The input Frame{}  is a cell array of structures
%   as specified by the user in userData.m. There must be one Frame{}
%   per each frame type considered. See userData.m for details.

%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.

for frm = 1:Opt.map.numFrames

    Frm(frm).frm = frm;
    Frm(frm).id = [];
    Frm(frm).used = false;
    Frm(frm).rob = [];
    Frm(frm).state.x = [];
    Frm(frm).manifold.x = [];
    Frm(frm).manifold.active = false;
    
end