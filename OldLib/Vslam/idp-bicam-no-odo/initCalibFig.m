if plotCalib

    if ~ishandle(4)
        fig4 = figure(4);
        set(fig4,'pos',[1 550 396 291])
    else
        fig4 = figure(4);
    end
    clf
    
    ax41 = gca;
    set(ax41,'pos',[.07 .07 .86 .86])


    ec   = zeros(3,fmax-fmin+2);
    eec  = zeros(3,fmax-fmin+2);
    ff   = repmat((fmin-1):fmax,3,1);
    calib = line(ff',ec','linewidth',2);
    cal_s = line(ff',eec','linestyle','-','linewidth',1);
    cal_s(4:6) = line(ff',eec','linestyle','-','linewidth',1);
    
    axis([fmin-1 80 -1 6]);
    grid;
    title('Right camera angles')
    legend('roll','pitch','yaw','location','east')

    % delete all lines
    for i=1:3
        set(calib(i),  'xdata',[],'ydata',[]);
        set(cal_s(i),  'xdata',[],'ydata',[]);
        set(cal_s(i+3),'xdata',[],'ydata',[]);
    end

    cr   = Cam(2).r;
    q_rs = Map.X(cr);       % sensor quaternion
    Qrs  = Map.P(cr,cr);    % sensor noise
    [e_rc,ERCqrs]  = qrs2erc(q_rs); % camera Euler and Jacobian
    Erc  = ERCqrs*Qrs*ERCqrs';    % camera noise

    ec(:,1)  = rad2deg(e_rc);
    eec(:,1) = rad2deg(sqrt(diag(Erc)));

    c0 = repmat(selfCalib2,1,fmax-fmin+2);


end
