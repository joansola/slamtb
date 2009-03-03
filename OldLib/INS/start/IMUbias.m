% IMUBIAS Compute acc and gyro biases from standstill sensed data

clear

insid = 2; % INS identifier: 1 to 4.

% Local frame, ENU
lat = deg2rad(38.737); % Site Latitude
wE  = [0;cos(lat);sin(lat)]*2*pi/24/60/60; % Earth's angular rates vector
gE  = [0;0;-9.8]; % Earth's gravity vector


%%
expDir = '~/Desktop/VMO/ErrorAnalysis/HFIMU/course1-DTED4-run2_Fri_Aug_24_11.08.51_2007_vo/';
fimu = fopen([expDir 'course1-DTED4-run2_Fri_Aug_24_11.08.51_2007_pose.txt'],'r');
[data,ncount] = fscanf(fimu,'%f',[34,5]);
f   = data';
t0  = f(5,2); % Initial time
p0  = f(insid,5:7)';
frewind(fimu); % Rewind file

% continuous and discrete time limits
tmax = 230;
kmax = tmax/0.01;

tt = zeros(1,kmax);
[aam,wwm,ppm,eem,pps] = deal(zeros(3,kmax));

t    = 0;
k    = 0;
while t < tmax
    k = k + 1;
    % Readings
    [data,ncount] = fscanf(fimu,'%f',[34,5]);
    f  = data';
    t  = f(5,2) - t0;
    am = 9.84*f(5,8:10)';
    wm = deg2rad(f(5,5:7))';
    pm = f(insid,5:7)' - p0;
    em = deg2rad(f(insid,14:16));
    ps = f(insid,11:13);

    % Collect data
    [tt(k),aam(:,k),wwm(:,k),ppm(:,k),eem(:,k),pps(:,k)] = deal(t,am,wm,pm,em,ps);
    
end
fclose('all');
%%
% Cut series at maximum registered time
[tt,aam,wwm,ppm,eem,pps]    = deal(tt(1:k),aam(:,1:k),wwm(:,1:k),ppm(:,1:k),eem(:,1:k),pps(:,1:k));

% Get means and statistics
[am_mean,am_std] = deal(mean(aam,2),std(aam,0,2));
[wm_mean,wm_std] = deal(mean(wwm,2),std(wwm,0,2));
[pm_mean,pm_std] = deal(mean(ppm,2),std(ppm,0,2));
[em_mean,em_std] = deal(mean(eem,2),std(eem,0,2));
ps_mean          = mean(pps,2);

% Body orientation from INS
Rwb = e2R(em_mean);
[qm,QMem] = e2q(em_mean);

% Sensor biases and jacobians
[ba,BAam,BAqm,BAg]  = abias(am_mean,qm,gE);
[bg,BGwm,BGqm,BGwe] = gbias(wm_mean,qm,wE);
BAem = BAqm*QMem;
BGem = BGqm*QMem;

% Sensed uncertainties
WM = diag(wm_std.^2/k);
AM = diag(am_std.^2/k);
EM = diag(em_std.^2/k);

% Uncertainties
BA = BAam*AM*BAam' + BAem*EM*BAem';
BG = BGwm*WM*BGwm' + BGem*EM*BGem';
QM = QMem*EM*QMem';

% Results
em_mean
EM
qm
QM
ba
BA
bg
BG




%%
figure(99)
set(99,'name','IMU bias.')
subplot(3,2,1)
plot(tt,aam)
title('Acc. readings')
grid
subplot(3,2,2)
plot(tt,wwm)
title('Gyro readings')
grid
subplot(3,2,3)
plot(tt,ppm)
title('INS position')
grid
subplot(3,2,4)
plot(tt,rad2deg(eem))
title('INS Euler angles')
grid
subplot(3,2,5)
plot(tt,pps)
title('INS position std')
grid
