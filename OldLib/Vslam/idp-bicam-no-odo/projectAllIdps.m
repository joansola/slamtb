for i = find([Lmk.Idp.used])
    for rob = 1:2
        cam = rob;
        Lmk.Idp(i) = projectIdp(Rob(rob),Cam(cam),Lmk.Idp(i),Obs.R,warpMethod);
    end
end
