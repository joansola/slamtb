for idx = find([Obj.used])
    for cam = 1:2
        Obj(idx) = projectObject(Cam(cam),Obj(idx),Obs(cam).R);
    end
end
