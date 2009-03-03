
clear
x  = 15;
n  = 15;
nh = (n-1)/2;
sc = zeros(1,2*x+1);
snr = 0;

% l = 88;
% c = 280;

if exist('Y')~=1
    filename = sprintf('/Volumes/Donnees/Doctorat/slam/Vslam/FIS-SLAM/Experiments/Dala/serie29/images/originals/image.001.d');
    Y  = imread(filename);
        Y  = single(fix(sum(Y,3)/3));
    sx = size(Y);
end

l = ceil(nh + (sx(1)-n)*rand);
l = ceil(nh + (200-n)*rand);
c = ceil(nh + x + (sx(2)-n-2*x)*rand);
Z = Y+snr*rand(size(Y));
I = Z(l-nh:l+nh,c-nh:c+nh);
X = Z(l-nh:l+nh,c-x-nh:c+x+nh);

% Original image recovery
In = I;

% brightness and contrast alterations
% In = In/1.2+.1;

% noise addition
% In = In+snr*(rand(n)-.5)*256;

figure(1)
subplot(3,1,1)
image(X)
ax1=gca;
axis equal
axis image
colormap(gray(84))
subplot(3,1,2)
image(In)
ax2=gca;
axis equal
axis image

for d = 1:2*x+1
    J = X(:,d:d+n-1);
    zn(d)=zncc(In,J);
    sd(d)=ssd(In,J)/84;
    cn(d)=census(In,J);
end



subplot(3,1,3)
% plot(1:2*x+1,zn,1:2*x+1,2*sd,1:2*x+1,2*cn-1)
plot(1:2*x+1,zn)
axis([1 2*x+1 -.5 1.1])
figure(2)
plot(1:2*x+1,zn)
ax3=gca;
axis([1 2*x+1 -.5 1.1])
% legend('zncc','ssd','census',2)