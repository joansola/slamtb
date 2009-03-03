for i = find([Lmk.Pnt.used])
    for cam = 1:2
        Lmk.Pnt(i) = projectPnt(Rob,Cam(cam),Lmk.Pnt(i),Obs(cam).R);
    end
end
