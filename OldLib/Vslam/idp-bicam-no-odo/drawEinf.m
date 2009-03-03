function [eInfHdle,eInf] = drawEinf(eInfHdle,eInf,ns)

% DRAWEINF  Draw innovation at infinity point

if eInf.used

    [ex,ey] = cov2elli(eInf.u,eInf.Z,ns,16);
    set(eInfHdle.elli,'xdata',ex,'ydata',ey);

    eInf.used = 0;

else

    set(eInfHdle.elli,'xdata',[],'ydata',[]);
    set(eInfHdle.obs,'xdata',[],'ydata',[]);

end


