function [Frm] = addFrameToGraph(Rob,Frm)


global Map

% Get free space in Map
rx = find(~Map.used.s, Rob.state.size, 'first');
rm = find(~Map.used.m, Rob.manifold.size, 'first');

% Get a free Frame in structure array Frm
frm = find(~[Frm.used], 1, 'first');

if ~isempty(frm) && length(rx) == Rob.state.size && length(rm) == Rob.manifold.size
    
    % Transfer Rob data to Frm
    Frm(frm) = rob2frm(Rob);
    Frm.used = true;
    
end
