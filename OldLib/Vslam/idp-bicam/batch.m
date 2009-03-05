N = 100;
simuLength = 200;

fmin = 10;
fmax = fmin+simuLength;

EC   = zeros(3,fmax-fmin+2,N);
EEC  = zeros(3,fmax-fmin+2,N);

for iii = 1:N

    fmin = fmin+2
    fmax = fmin+simuLength

    save batch_calib_.mat iii EC EEC fmin fmax N simuLength



    idpBicam;

    load batch_calib_.mat

    EC(:,:,iii) = ec;
    EEC(:,:,iii) = eec;

end

EC_mean = mean(EC,3);
EC_std = std(EC,1,3);
EEC_mean = mean(EEC,3);
EEC_std = std(EEC,1,3);

save batch_calib.mat EC EEC EC_mean EC_std EEC_mean EEC_std


%% plot
load batch_calib_save.mat

initCalibFig


fig4 = figure(4);
clf
ax41 = gca;

set(fig4,'pos',[1 550 396 291])
set(ax41,'pos',[.07 .07 .86 .86])

ec   = EC_mean;
eec  = EEC_mean;
ff   = repmat(1:size(EC_mean,2),3,1);
calib = line(ff',ec','linewidth',1);
cal_s = line(ff',eec','linestyle','-','linewidth',1);
cal_s(4:6) = line(ff',eec','linestyle','-','linewidth',1);

axis([ff(1) ff(end) -1 6]);
grid;
title('Right camera angles')
legend('roll','pitch','yaw','location','east')

c0 = repmat(selfCalib2,1,fmax-fmin+2);

for i=1:3
    set(calib(i),  'xdata',ff','ydata',ec(i,:)');
    set(cal_s(i),  'xdata',ff','ydata',c0(i,:)'+3*eec(i,:)');
    set(cal_s(i+3),'xdata',ff','ydata',c0(i,:)'-3*eec(i,:)');
end

% cr   = Cam(2).r;
% q_rs = Map.X(cr);       % sensor quaternion
% Qrs  = Map.P(cr,cr);    % sensor noise
% [e_rc,ERCqrs]  = qrs2erc(q_rs); % camera Euler and Jacobian
% Erc  = ERCqrs*Qrs*ERCqrs';    % camera noise
% 
% ec(:,1)  = rad2deg(e_rc);
% eec(:,1) = rad2deg(sqrt(diag(Erc)));
