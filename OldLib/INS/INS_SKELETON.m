clear

%% OPTIONS
tmax      = 300;
animation = 0;
vo_icov   = 0;  % Uses covariance from VO logs
covfactor = 1;  % factor for cov. matrix
refid     = 2;  % reference: 1-WAAS, 2-RTK, 3-waas, 4-rtk
tfilt     = 0;
tdisp     = 0;
tkey      = 236; % initial time without key-frames (all VO relates to first frame)
dispquat  = 0;
writefile = 0;  % set to write the log 'data-tight.m'
vo_quat   = 0;  % VO comes in quat. 0 for Euler
disp_vel  = 1;  % display VO as velocities instead of increments
updates   = [1 0]; % VO
gpsfactor = 1;  % cov factor for GPS updates
plot_traj = 1;
plot_vel  = 0;
MDth      = 3;
reset_P   = 1;
subst_vel = 0;

t_skip = [...   % enter time intervals to skip corrections
    250 260
    300 310
    360 350
    400 410];
t_skip = zeros(0,2);  % no correction skips

%%
if animation
    xylim = 100;
    zlim  = 30;
    a10   = 0;
    A10   = 10;
    initGraph % this is for the animation
    %     view(0,90);
    grid
    drawnow
end

% Local frame, ENU
lat = deg2rad(38.737); % Site Latitude
wE  = [0;cos(lat);sin(lat)]*2*pi/24/60/60; % Earth's angular rates vector
gE  = [0;0;-9.7951624]; % Earth's gravity vector

% constants
Z33 = zeros(3);
Z44 = zeros(4);
Z34 = zeros(3,4);
Z43 = Z34';
I33 = eye(3);
I44 = eye(4);

%% OPEN FILES FOR READ ACCESS
expDir = '~/Desktop/VMO/ErrorAnalysis/Ft-Carson/2007.08/2007.08.24/course1-DTED4-run2/';
voDir  = 'data-no-key/';

% IMU and logs
fimu  = fopen([expDir 'course1-DTED4-run2_Fri_Aug_24_11.08.51_2007_pose.txt'],'r');
data  = fscanf(fimu,'%f',[34,10])';
pref0 = data(refid,5:7)';
t0    = data(5,2);      % Initial time
t     = data(10,2) - t0;
tant  = 0;
k     = 0;
t10   = 0;

% VO
fvo    = fopen([expDir voDir 'data-vo-noskips.m'],'r'); 
datavo = fscanf(fvo,'%f',[12,2])';
tvoant = datavo(1,12) - t0;
tvo    = datavo(2,12)' - t0; % initial position
voant  = datavo(1,1:6)';
vom    = datavo(2,1:6)';
pvo0   = vom(1:3);
pvo    = pvo0;
datavo = datavo(2,:);
kvo    = 0;

% COVARIANCE
ficov  = fopen([expDir voDir 'data-icov-noskips.m'],'r');
dataicov = fscanf(ficov,'%f',[36,2])';
dataicov = dataicov(2,:);

%% Files for write access
if writefile
    ftightid = fopen([expDir voDir 'data-tight.m'],'w'); %#ok<MCMFL> % tight fusion VO-IMU
end

%% From IMUbias.m:
%acc and gyro biases
bam = [0.110367389417219;-0.028676765911575;-0.014994669199131];
bgm = 1.0e-04 * [0.002896349323177;0.093615037014923;-0.241419003990705];
% State
qm = [0.501115536860695 % pitch and roll from averaged 200s of acc. and yaw from INS
  -0.045989144439640
  -0.008003501508232
  -0.864120455303620];

%%

% init state vector and covariance
p  = [0;0;0];
v  = [0;0;0];
q  = qm;
ba = [0;0;0];
bg = [0;0;0];

% uncertainties
uncertainties;

% continuous and discrete time limits
kmax = tmax/0.01;
kvomax = tmax/0.1;

% data for collection
ti = zeros(1,kmax);
tv = zeros(1,kvomax);
[vt,ft,rt] = deal(zeros(3,kmax));

% time evolution
fprintf('\nElapsed time:    0 s')
while t < tmax  % IMU time.
    if t > t10
        fprintf('\b\b\b\b\b\b%4d s',t10);
        t10 = t10+10;
    end

    dt = t - tant;

    % PROCESS HERE
    if (t > tfilt) && (dt > 0.001)

        k  = k + 1;

        % IMU readings
        am = 9.84*data(5,8:10)';
        wm = deg2rad(data(5,5:7))';
        
        % Inertial quantities
        [ai,AIam,AIq]      = invacc(am,q,ba,gE);        
        [wi,WIwm,WIbg,WIq] = invgyro(wm,bg,q,wE);

        % Nominal state integration
        [p,Pp,Pv,Pai]  = rpredict(p,v,ai,dt);
        [v,Vv,Vai]     = vpredict(v,ai,dt);
        [q,Qq,Qwi]     = qpredict(q,wi,dt,'exact');

        % Jacobians
        Pam = Pai*AIam;
        Pq  = Pai*AIq;
        Vam = Vai*AIam;
        Vq  = Vai*AIq;
        Qwm = Qwi*WIwm;
        Qq  = Qq + Qwi*WIq;

        % Full Jacobians

        % VO time
        if t >= tvo - 0.005 % VO time
            kvo  = kvo + 1;
            dtvo = tvo - tvoant;

            % PROCESS HERE
            if dtvo > .05
                % VO measurement
                vom    = datavo(1:6)';
                pvo    = vom(1:3);

                % Obtain VO incremental position and orientation
                dvo    = poses2incPose(voant,vom);
                dp     = dvo(1:3);
                de     = dvo(4:6);
                Vvo    = dp/dtvo; % Local mean velocity from VO

                if vo_icov % we use covariances logs from VO
                    % Obtain VO covariances matrix
                    iNvo   = reshape(dataicov,6,6);
                    [V,D]  = svd(iNvo);
                    d      = diag(D);
                    d(d<1e-4) = 1e-4;  % maximum of 100m uncertainty
                    Nvo    = covfactor*V*diag(d.^-1)*V'; % this is in euler space
                    Ndp    = Nvo(1:3,1:3); % this is just position
                else % we use constant values for VO covariance
                    Ndp    = Nvo(1:3,1:3); % this is just position
                end

            end

            % data collection

            % write log
            if writefile
                fprintf(ftightid,'%f %f %f %f %f %f %d %d %d %d %f %f \n',p+pvo0,q2e(q),datavo(7:12));
            end

            % GET NEXT READING
            datavo = fscanf(fvo,'%f',[12,1])';
            if isempty(datavo),break,end
            tvoant = tvo;
            tvo    = datavo(12) - t0;
            voant  = vom;

            dataicov = fscanf(ficov,'%f',[36,1])';

        end

        % DATA COLLECTION

    end

    % ANIMATION
    if animation && t>tdisp
        if a10 >= A10
            a10     = 1;
            [p,v]   = pvq(x);
            F.X     = [p;q];
            F       = updateFrame(F);
            VOwing  = drawGraph(VOwing,F);
            pref    = data(refid,5:7)'-pref0;
            eref    = deg2rad(data(refid,14:16))';
            qref    = e2q(eref);
            F.X     = [pref;qref];
            F       = updateFrame(F);
            Twing   = drawGraph(Twing,F);
            pant = p;
            prefant = pref;
            drawnow
        else
            a10 = a10 + 1;
        end
    end

    % GET NEXT READING
    tant  = t;
    data  = fscanf(fimu,'%f',[34,5])';
    t     = data(5,2) - t0;

end
fprintf('\n')
fclose('all');


%% PLOTS
ti(k:end)      = [];
tv(kvo:end)    = [];
nrows = 1;

figure(2)
moreindatatip
set(2,'name','INS filter. States and STD')
subplot(nrows,2,1)
plot(ti,ti)
title('States')
ylabel('Positions [m]')
grid
subplot(nrows,2,2)
plot(ti,ti)
title('Standard deviations')
grid


%%
figure(2);for i=1:nrows*2,subplot(nrows,2,i),xlim([250 260]),end

%%
figure(2);for i=1:nrows*2,subplot(nrows,2,i),xlim([0 tmax]),end


%% trajectories
if plot_traj
    rt(:,k:end) = [];
    vt(:,k:end) = [];
    ft(:,k:end) = [];
    figure(3)
    moreindatatip
    [X,Y,Z] = series2xyz(ft',vt',rt');
    plot3(X,Y,Z)
    legend('fused','VO','RTK','location','best')
    axis equal
    view(0,90)
    grid
end

%% IMU and VO, compared
if plot_vel
    figure(4)
    subplot(2,2,1)
    plot(ti,xxv,'-');
    hold on
    plot(tv,vvv(1:3,:),'--');
    hold off
    title('State (solid) and VO (dashed) velocities [m/s]')
    grid
    subplot(2,2,2)
    plot(ti,rad2deg(mm(4:6,:)),'-');
    hold on
    plot(tv,rad2deg(vvv(4:6,:)),'--');
    hold off
    title('IMU (solid) and VO (dashed) angular rates [deg/s]')
    grid
    subplot(2,2,3)
    plot(tv,cc(1:3,:))
    title('VO trans. std. [m]')
    grid
    subplot(2,2,4)
    plot(tv,rad2deg(cc(4:6,:)))
    title('VO rot. std. [deg]')
    grid


%%
    figure(4);for i=1:4,subplot(2,2,i),xlim([240 320]),end

%%
    figure(4);for i=1:4,subplot(2,2,i),xlim([0 tmax]),end
%%
end

