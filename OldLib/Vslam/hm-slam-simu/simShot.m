function pixels = simShot(Rob,Cam,points3d,pixNoise)

n = size(points3d,2);

[pixels,d,f] = robCamPhoto(Rob,Cam,points3d);

if nargin == 4
    pixels = pixels + repmat(pixNoise,1,n).*randn(2,n);
end

pixels(:,f==0) = inf;

