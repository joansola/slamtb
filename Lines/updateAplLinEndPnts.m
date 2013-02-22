function Lmk = updateAplLinEndPnts(Rob,Sen,Lmk,Obs,Opt)

% UPDATEAPLLINENDPNTS  Update anchored Plucker endpoints.
%   Lmk = UPDATEAPLLINENDPNTS(Rob,Sen,Lmk,Obs,Opt) updates endpoint
%   abscissas in anchored Plucker line Lmk by using the last observation
%   Obs and the options in Opt.
%
%   See also UPDATELMKPARAMS, RETROPROJAPLENDPNTS.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


[seg, t] = retroProjAplEndPnts(Rob,Sen,Lmk,Obs);

if Opt.correct.lines.extPolicy

    lambda1 = sqrt(svd(Obs.par.endp(1).E)); % eigenvalues of the endpoints covariance
    lambda2 = sqrt(svd(Obs.par.endp(2).E)); % eigenvalues of the endpoints covariance

    if max(lambda1(1),lambda2(1)) < Opt.correct.lines.extSwitch % compare to threshold
        
        % extend endpoint 1
        if t(1) < Lmk.par.endp(1).t  
            Lmk.par.endp(1).t = t(1);
            Lmk.par.endp(1).e = seg(1:3);
        end

        % extend endpoint 2
        if t(2) > Lmk.par.endp(2).t  
            Lmk.par.endp(2).t = t(2);
            Lmk.par.endp(2).e = seg(4:6);
        end
        
    else  % set the endpoints following the last observation
        Lmk.par.endp(1).t = t(1);
        Lmk.par.endp(2).t = t(2);
        Lmk.par.endp(1).e = seg(1:3);
        Lmk.par.endp(2).e = seg(4:6);
    end

else  % leave the original endpoints unchanged forever
%     Lmk.par.endp(1).t = t(1);
%     Lmk.par.endp(2).t = t(2);
%     Lmk.par.endp(1).e = seg(1:3);
%     Lmk.par.endp(2).e = seg(4:6);
end










