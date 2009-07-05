function Lmk = updateLmkParams(Rob,Sen,Lmk,Obs,Opt)

% UPDATELMKPARAMS Update off-filter landmark parameters.

switch Sen.type

    case 'pinHole'

        switch Lmk.type
            case {'eucPnt','idpPnt','hmgPnt'}
                % do nothing

            case 'plkLin'
                % update endpoints
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


            otherwise
                error('??? Unknown landmark type ''%s''.',Lmk.type)
        end

    otherwise
        error('??? Unknown sensor type ''%s''.',Sen.type)
end

