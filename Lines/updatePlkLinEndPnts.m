function Lmk = updatePlkLinEndPnts(Rob,Sen,Lmk,Obs,Opt)

% UPDATEPLKLINENDPNTS  Update Plucker endpoints.
%   Lmk = UPDATEPLKLINENDPNTS(Rob,Sen,Lmk,Obs,Opt) updates endpoint
%   abscissas in Plucker line Lmk by using the last observation Obs and the
%   options in Opt.
%
%   See also UPDATELMKPARAMS, RETROPROJPLKENDPNTS.

[seg, t] = retroProjPlkEndPnts(Rob,Sen,Lmk,Obs);

if Opt.correct.lines.extPolicy

    lambda = sqrt(svd(Obs.par.endp(1).E));
    if lambda(1) < Opt.correct.lines.extSwitch
        if t(1) < Lmk.par.endp(1).t
            Lmk.par.endp(1).t = t(1);
            Lmk.par.endp(1).e = seg(1:3);
        end
        if t(2) > Lmk.par.endp(2).t
            Lmk.par.endp(2).t = t(2);
            Lmk.par.endp(2).e = seg(4:6);
        end
    else
%         Lmk.par.endp(1).t = -20;
%         Lmk.par.endp(2).t = 20;
        Lmk.par.endp(1).t = t(1);
        Lmk.par.endp(2).t = t(2);
        Lmk.par.endp(1).e = seg(1:3);
        Lmk.par.endp(2).e = seg(4:6);
    end

else
    Lmk.par.endp(1).t = t(1);
    Lmk.par.endp(2).t = t(2);
    Lmk.par.endp(1).e = seg(1:3);
    Lmk.par.endp(2).e = seg(4:6);
end

