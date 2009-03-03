for i = find([Lmk.Idp.used])
    for cam = 1:2
        Lmk.Idp(i) = projectIdp(Rob,Cam(cam),Lmk.Idp(i),Obs.R);
    end
end
