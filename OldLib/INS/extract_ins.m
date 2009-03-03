% OPEN FILES FOR READ AND WRITE ACCESS
% crusher log  -  input IMU and INS
insid  = 4;
imuid  = 5;
expDir = '~/Desktop/VMO/ErrorAnalysis/HFIMU/course1-DTED4-run2_Fri_Aug_24_11.08.51_2007_vo/';
fcru   = fopen([expDir 'course1-DTED4-run2_Fri_Aug_24_11.08.51_2007_pose.txt'],'r');
data   = fscanf(fcru,'%f',[34,5])';
timu   = data(imuid,2);       % Initial IMU time
k      = 0;

tins = data(insid,2);
tant = 0;

% output IMU and INS files
fimu = fopen([expDir 'data-from-ins/data-imu.m'],'w');
fins = fopen([expDir 'data-from-ins/data-ins.m'],'w');
fprintf('\nt:     ')

while 1
%     fprintf(fimu,'%d %.3f %d %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %d %d %d %d %d %d %d %.3f %d %d %.3f\n',data(5,:)');

    if  mod(k,10) == 0
        p = data(insid,5:7);
        e = deg2rad(data(insid,14:16));
        t = data(insid,2);
        d = [p e 0 0 0 0 0 t];
        fprintf(fins,'%f %f %f %f %f %f %d %d %d %d %d %f\n',d);
        if ~mod(k,1000)
            fprintf('\b\b\b\b%4d',k/1000)
        end
    end

    data = fscanf(fcru,'%f',[34,5])';
    if isempty(data)
        break
    end
    tant = tins;
    tins = data(2,2);
    k = k+1;

end

fprintf('\n')
fclose('all')

