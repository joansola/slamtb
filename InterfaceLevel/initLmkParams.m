function [Lmk,Obs] = initLmkParams(Rob,Sen,Lmk,Obs)

% INITLMKPARAMS  Initialize off-filter landmark parameters.

global Map

% Init internal state
switch Lmk.type
    case {'eucPnt','idpPnt','hmgPnt'}
    case 'plkLin'
        l  = Map.x(Lmk.state.r);
        t1 = -8;
        t2 =  8;
        Lmk.par.endp(1).t = t1;
        Lmk.par.endp(2).t = t2;
        [e1,e2] = pluckerEndpoints(l, t1, t2);
        Lmk.par.endp(1).e = e1;
        Lmk.par.endp(2).e = e2;

        %             [seg, t] = retroProjPlkEndPnts(Rob,Sen,Lmk,Obs);
        %             Lmk.par.endp(1).t = t(1);
        %             Lmk.par.endp(2).t = t(2);
        %             Lmk.par.endp(1).e = seg(1:3);
        %             Lmk.par.endp(2).e = seg(4:6);

        Obs.par.endp(1).e = Obs.meas.y(1:2);
        Obs.par.endp(2).e = Obs.meas.y(3:4);
        Obs.par.endp(1).E = Obs.meas.R(1:2,1:2);
        Obs.par.endp(2).E = Obs.meas.R(3:4,3:4);


    otherwise
        error('??? Unknown landmark type ''%s''.',Lmk.type);
end
