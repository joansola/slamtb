function Lmk = updateLmkParams(Rob,Sen,Lmk,Obs,Opt)

global Map 

switch Sen.type
    
    case 'pinHole'
    
        switch Lmk.type
            case {'eucPnt','idpPnt','hmgPnt'}
                % do nothing
        
            case 'plkLin'
                % update endpoints
                [seg, t] = retroProjPlkEndPnts(Rob,Sen,Lmk,Obs);
                
                if Opt.correct.lines.extPolicy
                    l = Map.x(Lmk.state.r);
                    [E1,E2,E1_l] = pluckerEndpoints(l,t(1),t(2));
                    
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

