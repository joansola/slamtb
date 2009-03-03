%function  dispElli = displayEllipses(dispElli,NEllip,ns,NP)
function  dispElli = displayEllipses(dispElli,ns,NP)

global Map
persistent nEllip

if isempty(nEllip)
    nEllip = 0;
end

used   = Map.used(Map.used~=0)';
lUsed  = length(used);
nEllip = max(nEllip,lUsed);

for e = 1:nEllip
    
    if e <= lUsed
    
        rngElli    = loc2range(used(e));
        [ex,ey,ez] = cov3elli(Map.X(rngElli),Map.P(rngElli,rngElli),ns,NP);

    else
        
        ex = [];
        ey = [];
        ez = [];
    
    end
    
    set(dispElli(e),...
        'xdata',ex,...
        'ydata',ey,...
        'zdata',ez);

end

nEllip = lUsed;
