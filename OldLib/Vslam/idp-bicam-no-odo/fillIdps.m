function Idp = fillIdps(maxIdp)

% FILLRAYS  Fill rays structure
%   RAY = FILLRAYS(NRAYS) initializes rays structure RAY and sets 
%   all NRAYS rays to the initial null state by doing:
%
%     Idp(i).used    = false
%     Idp(i).vis0    = false
%     Idp(i).front   = false
%     Idp(i).s       = 0
%     Idp(i).matched = false
%     Idp(i).updated = false
%
%   See also FILLPNTS


for i = 1:maxIdp
    Idp(i)         = emptyIdp(2); % Idps structure array
end
