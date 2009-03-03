function dispProjIdp = dispProjIdps(dispProjIdp,ns)

% DISPPROJIDPS  display projected points

global Lmk Map

elli    = ones(1,2);  % ellipses counters L and R
cent{1} = zeros(2,0); % centers array L
cent{2} = zeros(2,0); % centers array R
obs{1}  = zeros(2,0); % observed pixels array L
obs{2}  = zeros(2,0); % observed pixels array R

for p = 1:Lmk.maxIdp
    idp = Lmk.Idp(p);

    for cam = 1:2
        prj = idp.Prj(cam);

        if prj.updated == 1
            clr = 'r';
        else
            clr = 'm';
        end

        if idp.used && prj.vis
            % ellipse
            u  = prj.u;
            Z  = prj.Z;
            [ellix,elliy] = cov2elli(u,Z,ns,16);
            ellitxt = [num2str(idp.id) ' - ' num2str(100*prj.sc,'%.0f')]; % identifier
            ellitxtpos = u+[0;-7];

            % center
            cent{cam} = [cent{cam} prj.u];

            % observation
            if prj.matched
                obs{cam} = [obs{cam} prj.y];
            end
        else
            ellix = [];
            elliy = []; % no ellipse
            ellitxt = ''; % no identifier
            ellitxtpos = [1;1];

        end

        set(dispProjIdp(cam).elli(elli(cam)),...
            'xdata',ellix,...
            'ydata',elliy,...
            'color',clr)

        set(dispProjIdp(cam).txt(elli(cam)),...
            'position',ellitxtpos,...
            'string',ellitxt)
        
        Lmk.Idp(p).Prj(cam).matched = 0;
        Lmk.Idp(p).Prj(cam).updated = 0;

        elli(cam) = elli(cam)+1;

    end
end

% centers and observations
for cam = 1:2
    if ~isempty(cent{cam})
        cx = cent{cam}(1,:);
        cy = cent{cam}(2,:); % center points
    else
        cx=[];
        cy=[]; % no points
    end
    set(dispProjIdp(cam).center,'xdata',cx,'ydata',cy); % draw
    if ~isempty(obs{cam})
        ox = obs{cam}(1,:);
        oy = obs{cam}(2,:); % center points
    else
        ox=[];
        oy=[]; % no points
    end
    set(dispProjIdp(cam).obs,'xdata',ox,'ydata',oy); % draw
end


