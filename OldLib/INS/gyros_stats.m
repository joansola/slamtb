expDir = '~/Desktop/VMO/ErrorAnalysis/HFIMU/course1-DTED4-run2_Fri_Aug_24_11.08.51_2007_vo/';
if ~exist('alldata','var')
    alldata  = load([expDir 'course1-DTED4-run2_Fri_Aug_24_11.08.51_2007_pose.txt'],'r');
end

% IMU readings
imudata = alldata((alldata(:,1)==5),[2 8 9 10 5 6 7]);  % IMU time, acc and gyro values
imudata(:,1) = imudata(:,1) - imudata(1,1);       % Set time origin to 0
imudata(:,2:4) = imudata(:,2:4)*9.84;             % Correct for grav

% RTK readings
gpsdata = alldata((alldata(:,1)==1),[2 5 6 7 14 15 16]);
gpsdata(:,1) = gpsdata(:,1) - gpsdata(1,1);            % Set time origin to 0

% ranges
er = 5:7;

% Local frame, ENU
lat = deg2rad(38.737); % Site Latitude
wE  = [0;cos(lat);sin(lat)]*2*pi/24/60/60; % Earth's angular rates vector
gE  = [0;0;-9.8]; % Earth's gravity vector

% initial
q  = e2q(deg2rad(gpsdata(1,er)'));
bg = [0;0;0];
p  = [0;0;0];


% time
tmax = 3600;
t    = 0;
tans = 0;
kmax = tmax / 0.01;
t10  = 10;
T10  = 10;
T100 = 100;
t100 = 100;
k100 = zeros(1,round(tmax/T100));
e100 = zeros(3,round(tmax/T100));

% data
[ee,eegps] = deal(zeros(3,kmax));
tt = zeros(1,kmax);

% loop
k = 1;
fprintf('\nElapsed time:    0 s')
while t < tmax-.01  % IMU time.
    if t > t10
        fprintf('\b\b\b\b\b\b%4d s',t10);
        t10 = t10+T10;
    end

    % integrate gyros
    t  = imudata(k,1);
    dt = t - tans;
    wm = normAngle(deg2rad(imudata(k,er)))';
    wi = invgyro(wm,bg,q,wE);
    q  = qpredict(q,wi,dt,'exact');
    e  = q2e(q);
    ee(:,k) = e;
    
    % store GPS
    egps = normAngle(deg2rad(gpsdata(k,er)'));
    eegps(:,k) = egps;

    % store time
    tt(k) = t;
    
    % 100m runs
    if t > t100
        t100 = t100 + T100;
        k100 = k;
    end
    
    k    = k+1;
    tans = t;
    
end

%%
tt(:,k:end) = [];
ee(:,k:end) = [];
eegps(:,k:end) = [];

figure(1)
plot(tt,rad2deg(ee),tt,rad2deg(eegps))
legend('IMU roll','IMU pitch','IMU yaw','GPS roll','GPS pitch','GPS yaw','location','best')
grid
