% plot
load batch_calib_save.mat

initCalibFig


fig4 = figure(4);
clf
ax41 = gca;

set(fig4,'pos',[1 550 396 291])
set(ax41,'pos',[.07 .07 .86 .86])

MC_mean   = EC_mean;
MC_std  = EC_std;
KF_std  = EEC_mean;

ff   = repmat(1:size(EC_mean,2),3,1);

MCcalib = line(ff',MC_mean','linewidth',2);
MCcal_s = line(ff',MC_std','linestyle','-','linewidth',1);
MCcal_s(4:6) = line(ff',MC_std','linestyle','-','linewidth',1);

KFcal_s = line(ff',KF_std','linestyle','--','linewidth',1);
KFcal_s(4:6) = line(ff',KF_std','linestyle','--','linewidth',1);

axis([ff(1) ff(end) -1 6]);
grid;
title('Right camera angles')
legend('roll','pitch','yaw','location','east')

c0 = repmat(selfCalib2,1,fmax-fmin+2);

fr = ff(1,:);

for i=1:3
    set(MCcalib(i),  'xdata',fr','ydata',MC_mean(i,:)');
    set(MCcal_s(i),  'xdata',fr','ydata',c0(i,:)'+3*MC_std(i,:)');
    set(MCcal_s(i+3),'xdata',fr','ydata',c0(i,:)'-3*MC_std(i,:)');

    set(KFcal_s(i),  'xdata',fr','ydata',c0(i,:)'+3*KF_std(i,:)');
    set(KFcal_s(i+3),'xdata',fr','ydata',c0(i,:)'-3*KF_std(i,:)');
end


axis([ff(1) 100 -1 6]);


% cr   = Cam(2).r;
% q_rs = Map.X(cr);       % sensor quaternion
% Qrs  = Map.P(cr,cr);    % sensor noise
% [e_rc,ERCqrs]  = qrs2erc(q_rs); % camera Euler and Jacobian
% Erc  = ERCqrs*Qrs*ERCqrs';    % camera noise
% 
% ec(:,1)  = rad2deg(e_rc);
% eec(:,1) = rad2deg(sqrt(diag(Erc)));

