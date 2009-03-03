%% OPEN FILES FOR READ ACCESS
expDir = '~/Desktop/VMO/ErrorAnalysis/HFIMU/course1-DTED4-run2_Fri_Aug_24_11.08.51_2007_vo/';
voDir  = 'data-no-key/';

% INS
fimu   = fopen([expDir 'course1-DTED4-run2_Fri_Aug_24_11.08.51_2007_pose.txt'],'r');
dimu   = fscanf(fimu,'%f',[34,5])';
timu   = dimu(5,2);      % Initial time
gpsid  = 2;
tgps   = dimu(gpsid,2);  % GPS time
pgps0  = dimu(gpsid,5:7); % gps initial position
kimu   = 1;

% VO read
fvo    = fopen([expDir voDir 'data-vo.m'],'r');
dvo    = fscanf(fvo,'%f',[12,1])';
tvo    = dvo(1,12); % initial time
pvo0   = dvo(1,1:3); % initial position
kvo    = 0;
fvo0   = dvo(1,7);
dvo(1:3) = dvo(1:3) - pvo0;

% covariances read
fico = fopen([expDir voDir 'data-icov.m'],'r');
dico = fscanf(fico,'%f',[36,2])';
dico = dico(2,:);
frewind(fico);
fscanf(fico,'%f',[36,1])';

% VO and cov. write
fvow   = fopen([expDir voDir 'data-vo-noskips.m'],'w');
ficow  = fopen([expDir voDir 'data-icov-noskips.m'],'w');

% default VO sample time
dtvo = .1;

t   = timu; % operating time
d   = dvo;

% write zero velocities at the leading part of the file
while t < tvo - dtvo

    % compute fields
    f = floor(fvo0 - (tvo - t)/dtvo);
    d(7)  = f; % frame
    d(12) = t; % time

    % write VO
    fprintf(fvow,'%f %f %f %f %f %f %d %d %d %d %f %f\n',d);

    % write ICOV
    fprintf(ficow,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n',dico);

    % read INS
    t = t + dtvo;
    while tgps < t - 0.005
        dimu = fscanf(fimu,'%f',[34,5])';
        tgps = dimu(gpsid,2);
    end
    
end

% write all the rest of file, fill blanks with zeros
eof = 0;
while 1
    
    
    if tvo - t > 0.1 % next data line is still too far: get pose from GPS
        t = t + dtvo;
        d = dvo;
        d(12) = t;
        %         fprintf(fvow,'%f %f %f %f %f %f %d %d %d %d %f %f\n',d);
        %         fprintf(ficow,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n',dico);

        % read INS
        while tgps < t - 0.005
            dimu = fscanf(fimu,'%f',[34,5])';
            tgps = dimu(gpsid,2);
        end
    else

        % write VO and ICOV
        fprintf(fvow,'%f %f %f %f %f %f %d %d %d %d %f %f\n',dvo);
        fprintf(ficow,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n',dico);

        % write GPS at VO times
        pgps = dimu(gpsid,5:7);
        egps = normAngle(deg2rad(dimu(gpsid,14:16)));
        vgps = dimu(gpsid,21:23);
        tgps = dimu(gpsid,2);
        dgps = [(pgps-pgps0) egps vgps 0 0 tgps];
        fprintf(fgpsw,'%f %f %f %f %f %f %d %d %d %d %f %f\n',dgps);

        t       = tvo;

        dvo  = fscanf(fvo,'%f',[12,1])';
        dico = fscanf(fico,'%f',[36,1])';

        % read INS
        while tgps < t - 0.005
            dimu = fscanf(fimu,'%f',[34,5])';
            tgps = dimu(gpsid,2);
        end
        
        eof     = isempty(dvo) || isempty(dico) || isempty(dimu);
        if eof
            break
        end
        dvo(1:3) = dvo(1:3) - pvo0;
        tvo      = dvo(12);
    end
end

fclose('all');