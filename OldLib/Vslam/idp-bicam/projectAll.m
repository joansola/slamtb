% PROJECTALL  Project all to image plane

for i = find([Lmk.Pnt.used])
    for cam = 1:2
        Lmk.Pnt(i) = projectPnt(Rob,Cam(1),Lmk.Pnt(i),Obs);
    end
    Lmk.Pnt(i) = summarizePnt(Lmk.Pnt(i));
end

for i = find([Lmk.Ray.used])
    for cam = 1:length(Cam)
        Lmk.Ray(i) = projectRay(Rob,...
            Cam(cam),...
            Lmk.Ray(i),...
            Obs);
    end
    Lmk.Ray(i) = summarizeRay(Lmk.Ray(i));
end
