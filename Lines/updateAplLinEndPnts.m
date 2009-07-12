function Lmk = updateAplLinEndPnts(Rob,Sen,Lmk,Obs,Opt)

% UPDATEAPLLINENDPNTS  Update anchored Plucker endpoints.
%   Lmk = UPDATEAPLLINENDPNTS(Rob,Sen,Lmk,Obs,Opt) updates endpoint
%   abscissas in anchored Plucker line Lmk by using the last observation
%   Obs and the options in Opt.
%
%   See also UPDATELMKPARAMS, RETROPROJAPLENDPNTS.

[seg, t] = retroProjAplEndPnts(Rob,Sen,Lmk,Obs);

if Opt.correct.lines.extPolicy

    lambda = sqrt(svd(Obs.par.endp(1).E));

    if lambda(1) < Opt.correct.lines.extSwitch
        
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
        
    else
        Lmk.par.endp(1).t = t(1);
        Lmk.par.endp(2).t = t(2);
        Lmk.par.endp(1).e = seg(1:3);
        Lmk.par.endp(2).e = seg(4:6);
    end

else
%     Lmk.par.endp(1).t = t(1);
%     Lmk.par.endp(2).t = t(2);
%     Lmk.par.endp(1).e = seg(1:3);
%     Lmk.par.endp(2).e = seg(4:6);
end

