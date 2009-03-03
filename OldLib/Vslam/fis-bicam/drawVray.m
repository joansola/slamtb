function [vRayHdle,vRay] = drawVray(vRayHdle,vRay,ns)

% DRAWVRAY  Draw virtual ray

if vRay.used
    
    for cam = 1:2
        for p = 1:2
            u = vRay.Prj(cam).u(:,p);
            Z = vRay.Prj(cam).Z(:,:,p);
            [ex,ey] = cov2elli(u,Z,ns,16);
            set(vRayHdle.elli(cam,p),'xdata',ex,'ydata',ey,'color','g');
        end
        y = vRay.Prj(cam).y;
        set(vRayHdle.obs(cam),'xdata',y(1),'ydata',y(2));
        vRay.Prj(cam).matched = 0;
    end

    vRay.used = 0;
    
else
    
    for cam = 1:2
        for p = 1:2
            set(vRayHdle.elli(cam,p),'xdata',[],'ydata',[],'color','g');
        end
        set(vRayHdle.obs(cam),'xdata',[],'ydata',[]);
    end

end


