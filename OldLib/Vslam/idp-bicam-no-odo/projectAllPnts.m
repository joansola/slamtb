for i = find([Lmk.Pnt.used])
    for rob = 1:2
        cam = rob;
        Lmk.Pnt(i) = projectPnt(Rob(rob),Cam(cam),Lmk.Pnt(i),Obs.R,warpMethod);
    end
end
