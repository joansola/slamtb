function dispProjCam = dispPrjCam(dispProjCam,Rob,Cam)


c = get(dispProjCam,'userdata');

c.vert = fromFrame(Rob(1),fromFrame(Cam(1),c.vert0'))';

[p.vert,s,f] = robCamPhoto(Rob(2),Cam(2),c.vert');

if all(f)
    
    x = p.vert(1,:);
    y = p.vert(2,:);
    
    X = x(c.faces)';
    Y = y(c.faces)';

    set(dispProjCam,'xdata',X,'ydata',Y);

end

