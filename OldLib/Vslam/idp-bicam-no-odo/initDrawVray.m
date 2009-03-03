% INITDRAWVRAY  Initialize vRay graphics

vRayHdle.elli = zeros(2,2);
vRayHdle.obs  = zeros(2,1);

vrcolor(1:2,1:2) = 'g';
vrcolor(2,2) = 'y';


for cam=1:2
    for p=1:2
        vRayHdle.elli(cam,p) = line;
        set(vRayHdle.elli(cam,p),...
            'parent',ax2(cam),...
            'color',vrcolor(cam,p),...
            'linewidth',linewidth);
    end
    vRayHdle.obs(cam)  = line;
    set(vRayHdle.obs(cam),...
        'parent',ax2(cam),...
        'color','g',...
        'marker','.',...
        'linestyle','none');
end

