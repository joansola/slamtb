%% OPEN FILES FOR READ ACCESS
expDir = '~/Desktop/VMO/ErrorAnalysis/HFIMU/course1-DTED4-run2_Fri_Aug_24_11.08.51_2007_vo/';
voDir  = 'data-no-key/';

% INS
fimu   = fopen([expDir 'course1-DTED4-run2_Fri_Aug_24_11.08.51_2007_pose.txt'],'r');
data   = fscanf(fimu,'%f',[34,5])';
imuid  = 5;
gpsid  = 2;
dimu   = data(imuid,:);
timu   = dimu(2);      % Initial time
dgps   = data(gpsid,:);
pgps0  = dgps(5:7); % gps initial position
tgps   = dgps(2);
tgps0  = tgps;
t10    = tgps0;

% GPS at VO speed write
fgpsw  = fopen([expDir voDir 'data-gps-noskips.m'],'w');

eof = false;

% take on over 10 IMU readings and produce artificlal VO from GPS data
fprintf('\nElapsed time:    0 s')
while ~eof
    
    if tgps > t10
        fprintf('\b\b\b\b\b\b%4d s',t10-tgps0);
        t10 = t10+100;
    end

    
    % write GPS data at VO times to simulate a globally consistent VO
    dgps = data(gpsid,:);
    pgps = dgps(5:7);
    egps = normAngle(deg2rad(dgps(14:16)));
    vgps = dgps(21:23);
    tgps = dgps(2);
    sgps = [(pgps-pgps0) egps vgps 0 0 tgps];
    fprintf(fgpsw,'%f %f %f %f %f %f %d %d %d %d %f %f\n',sgps);

    % read INS
    for k = 1:10
        data = fscanf(fimu,'%f',[34,5])';
    end
    
    eof = isempty(data);
    
end

fprintf('\n');
fclose('all');