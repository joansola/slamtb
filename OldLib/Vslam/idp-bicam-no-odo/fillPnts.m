function Pnt = fillPnts(maxPnt)

% FILLPNTS  Fill points structure
%   PNT = FILLPNTS(NPNTS) initializes points structure PNT and
%   sets all NPTS points to the initial null state by doing:
%
%     Pnt(i).used    = false
%     Pnt(i).vis     = false
%     Pnt(i).front   = false
%     Pnt(i).s       = 0
%     Pnt(i).matched = false
%     Pnt(i).updated = false 
%
%   See also FILLRAYS


for i = 1:maxPnt
    Pnt(i)       = emptyPnt(2); % Points structure array
end    
