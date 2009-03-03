function Ray = fillRays(maxRay)

% FILLRAYS  Fill rays structure
%   RAY = FILLRAYS(NRAYS) initializes rays structure RAY and sets 
%   all NRAYS rays to the initial null state by doing:
%
%     Ray(i).used    = false
%     Ray(i).vis0    = false
%     Ray(i).front   = false
%     Ray(i).s       = 0
%     Ray(i).matched = false
%     Ray(i).updated = false
%
%   See also FILLPNTS


for i = 1:maxRay
    Ray(i)         = emptyRay(2); % Rays structure array
end
