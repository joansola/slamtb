function [u,Uh,Uc,Ud] = hmPinHole(hm,cam)

if nargout == 1

    switch nargin
        case 1
            u = hmProject(hm);
        case 2
            if ~isfield(cam,'dist')
                u = pixellise(hmProject(hm),cam.cal);
            else
                rmax2 = (cam.cal(1)/cam.cal(3))^2 + (cam.cal(2)/cam.cal(4))^2;
                rmax  = sqrt(rmax2); % maximum radius in normalized coordinates

                u = pixellise(distort(hmProject(hm),cam.dist,rmax),cam.cal);
                %             u = pixellise(distort(hmProject(hm),cam.dist),cam.cal);
            end
    end

else % we want jacobians

    switch nargin
        case 1
            [u,Uh] = hmProject(hm);
        case 2
            if ~isfield(cam,'dist')
                [x,Xh] = hmProject(hm);
                [u,Ux,Uc] = pixellise(x,cam.cal);

                Uh = Ux*Xh;

            else
                rmax2 = (cam.cal(1)/cam.cal(3))^2 + (cam.cal(2)/cam.cal(4))^2;
                rmax  = sqrt(rmax2); % maximum radius in normalized coordinates

                [x,Xh]       = hmProject(hm);
                [xd,XDx,XDd] = distort(x,cam.dist,rmax);
                [u,Uxd,Uc]   = pixellise(xd,cam.cal);

                Uh = Uxd*XDx*Xh;
                Ud = Uxd*XDd;

            end
    end
end



