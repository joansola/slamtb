function r = ranges(Str)

% RANGES Get ranges from structure array.
%   RANGES(Str) Get ranges collected from all ranges in structure array
%   Str. 
%
%   In general, Str is a structure array Str(:,:) with at least a
%   field Str.state.r, where the range of positions in the state vector is
%   stored.
%
%   In particular, Str is one of the following structures in SLAMTB or
%   SLAMTB_GRAPH:
%       Rob: a 1-dimensional array of robots 
%       Sen: a 1-D array of sensors
%       Lmk: a 1-D array of landmarks
%       Frm: a 2-D array of frames
%   
%   In any case, the output is a column vector of indices to the storage
%   vector in the Map, that is, Map.x.
%
%   See also NEWRANGE, BLOCKRANGE, FREESPACE.

%   Copyright 2015-   Joan Sola @ IRI-CSIC-UPC


states = [Str.state];
r = [states.r];
r = r(:);

