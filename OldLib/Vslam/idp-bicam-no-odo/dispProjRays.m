function [dispProjRay] = dispProjRays(dispProjRay,ns)

% DISPPROJRAYS  Display projected rays
%   [PH,OH] = DISPPROJRAYS(PH,OH) draws the projected rays
%   ellipses, centers and observed matches, with a color code
%   that indicates that a map updated has been performed. PH and
%   OH are the graphics handles of the projected and observed
%   rays

global Lmk

elli    = ones(1,2);  % ellipses counters L and R
cent{1} = zeros(2,0); % centers array L
cent{2} = zeros(2,0); % centers array R
obs{1}  = zeros(2,0); % observed pixels array L
obs{2}  = zeros(2,0); % observed pixels array R

% delete all ray graphics
set(dispProjRay(1).elli,'xdata',[],'ydata',[]);
set(dispProjRay(2).elli,'xdata',[],'ydata',[]);

for r = 1:Lmk.maxRay
    ray = Lmk.Ray(r);
    
    for cam = 1:2
        prj = ray.Prj(cam);
    
        if prj.updated == 1
            clr = 'r';
        else
            clr = 'm';
        end
        
        for n = 1:ray.Ng
        
            if ray.used && prj.vis0 
                if n <= ray.n
                    u  = prj.u(:,n);
                    Z  = prj.Z(:,:,n);
                    [ellix,elliy] = cov2elli(u,Z,ns,16); % ellipse
                end
                cent{cam} = [cent{cam} prj.u0];

                if prj.matched
                    obs{cam} = [obs{cam} prj.y];
                end

            else
                ellix = [];
                elliy = []; % no ellipse
            end

            set(dispProjRay(cam).elli(elli(cam)),...
                'xdata',ellix,...
                'ydata',elliy,...
                'color',clr)

            elli(cam) = elli(cam)+1;
        end

        Lmk.Ray(r).Prj(cam).matched = 0;
        Lmk.Ray(r).Prj(cam).updated = 0;

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
    set(dispProjRay(cam).center,'xdata',cx,'ydata',cy); % draw
    if ~isempty(obs{cam})
        ox = obs{cam}(1,:);
        oy = obs{cam}(2,:); % center points
    else
        ox=[];
        oy=[]; % no points
    end
    set(dispProjRay(cam).obs,'xdata',ox,'ydata',oy); % draw
end


