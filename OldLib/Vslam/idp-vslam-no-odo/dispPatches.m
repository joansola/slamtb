function dispPatches(dispPatch)

global Lmk

blankPatch = zeros(15);

% Rays
visRaysIdx = find([Lmk.Ray.vis0] & [Lmk.Ray.used]);
for i = 1:8
    if i <= length(visRaysIdx)
        idx = visRaysIdx(i);
        set(dispPatch(3*i-2),'cdata',Lmk.Ray(idx).sig.I);
        set(dispPatch(3*i-1),'cdata',Lmk.Ray(idx).wPatch.I);
        set(dispPatch(3*i),'cdata',Lmk.Ray(idx).cPatch.I);
        axc = get(dispPatch(3*i-1),'parent');
        tit = get(axc,'title');
        set(tit,'string',num2str(100*Lmk.Ray(idx).sc,'%.0f'),'fontsize',8);
    else
        set(dispPatch(3*i-2),'cdata',blankPatch);
        set(dispPatch(3*i-1),'cdata',blankPatch);
        set(dispPatch(3*i),'cdata',blankPatch);
        axc = get(dispPatch(3*i-1),'parent');
        tit = get(axc,'title');
        set(tit,'string','--');
    end
end

% Points
visPntsIdx = find([Lmk.Pnt.used] & [Lmk.Pnt.vis]); % visible points
for i = 1:16
    if i <= length(visPntsIdx)
        idx = visPntsIdx(i);
        set(dispPatch(24+3*i-2),'cdata',Lmk.Pnt(idx).sig.I);
        set(dispPatch(24+3*i-1),'cdata',Lmk.Pnt(idx).wPatch.I);
        set(dispPatch(24+3*i),'cdata',Lmk.Pnt(idx).cPatch.I);
        axc = get(dispPatch(24+3*i-1),'parent');
        tit = get(axc,'title');
        set(tit,'string',num2str(100*Lmk.Pnt(idx).sc,'%.0f'));
    else
        set(dispPatch(24+3*i-2),'cdata',blankPatch);
        set(dispPatch(24+3*i-1),'cdata',blankPatch);
        set(dispPatch(24+3*i),'cdata',blankPatch);
        axc = get(dispPatch(24+3*i-1),'parent');
        tit = get(axc,'title');
        set(tit,'string','--');
    end
end

