clear

% Frames per run
Nframes   = 120;

% Number of updates per frame
% UpPerFrame = [1 2 3 5 7 10 15 20 30 50];
UpPerFrame = [1 3 8 20 50];
% UpPerFrame = [2 8 ];

N = numel(UpPerFrame);

% Trajectory stats
ErrorTraj = zeros(6,Nframes,N);
SigmaTraj = zeros(6,Nframes,N);

for nn = 1:N
    
    hmSlamSimu;
    
end

%%
figure(3)
lab = {'x','y','z','roll','pitch','yaw'};
for dim = 1:6
subplot(2,3,dim)
    plot(2*squeeze(SigmaTraj(dim,:,:)),'linewidth',2)
grid on
hold on
plot(abs(squeeze(ErrorTraj(dim,:,:))))
hold off
legend(num2str(UpPerFrame'),0)
title(lab{dim})
end