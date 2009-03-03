function pixels = simShot(Rob,Cam,points3d)

[pixels,d,f] = robCamPhoto(Rob,Cam,points3d);

pixels(:,f==0) = inf;

