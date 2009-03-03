function Lmk = fillPnts(Lmk)

% FILLPNTS  Fill points structure
%   LMK = FILLPNTS(LMK) initializes points structure and sets 
%   all points to the unused state by doing:
%
%       LMK.Pnt(1:LMK.maxPnt).used = 0
%
%   See also FILLRAYS

Lmk.Pnt(Lmk.maxPnt) = emptyPnt(); % Points structure array

for i = 1:Lmk.maxPnt
    Lmk.Pnt(i).used  = false;
    Lmk.Pnt(i).vis   = false;
    Lmk.Pnt(i).front = false;
    Lmk.Pnt(i).s     = 0;
    Lmk.Pnt(i).matched = false; % Point matched
    Lmk.Pnt(i).updated = false; % Point updated
end    
