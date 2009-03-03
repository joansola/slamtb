for i = find([Lmk.Ray.used])
    for cam = 1:2
        Lmk.Ray(i) = projectRay(Rob,Cam(cam),Lmk.Ray(i),Obs(cam).R);
    end
end
