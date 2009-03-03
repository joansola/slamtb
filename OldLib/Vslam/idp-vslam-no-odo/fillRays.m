function Lmk = fillRays(Lmk)

% FILLRAYS  Fill rays structure
%   LMK = FILLRAYS(LMK) initializes rays structure and sets 
%   all rays to the unused state by doing:
%
%       LMK.Ray(1:LMK.maxRay).used = 0
%
%   See also FILLRAYS

Lmk.Ray(Lmk.maxRay) = emptyRay(); % Rays structure array

for i = 1:Lmk.maxRay
    Lmk.Ray(i).used    = false;
    Lmk.Ray(i).vis0    = false;
    Lmk.Ray(i).front   = false;
    Lmk.Ray(i).s       = 0;
    Lmk.Ray(i).matched = false; % Point matched
    Lmk.Ray(i).updated = false; % Point updated

end    
