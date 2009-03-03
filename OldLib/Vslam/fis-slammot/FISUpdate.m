function [Rob,Cam] = FISUpdate(Rob,Cam,Ray,Obs)

% FISUPDATE  Ray update using FIS
%   [ROB,CAM] = FISUPDATE(ROB,CAM,RAY,OBS)

global Map WDIM ODIM

prj = Cam.id;

for i = 1:Ray.n % for every point in the ray

    % get Ray parameters
    w    = Ray.w(i);

    if w > 0.05 % update only if the effect is noticeable

        % ray things
        loc  = Ray.loc(i);
        z    = Ray.Prj(prj).z(:,i);
        Hr   = Ray.Prj(prj).Hr(:,:,i);
        Hc   = Ray.Prj(prj).Hc(:,:,i);
        Hp   = Ray.Prj(prj).Hp(:,:,i);
        Hrc  = [Hr Hc];
        U    = Ray.Prj(prj).U(:,:,i);

        % Other parameters
        rr   = Rob.r;
        cr   = Cam.r;
        cor  = Cam.or;
        rcr  = [rr cr];
        pr   = loc2range(loc);
        R    = Obs.R;

        % Federated innovation covariance and inverse
        rho  = w;
        Rf   = R/rho;
        Zf   = U + Rf;    % now:  Zf = HPH' + R/rho
        iZf  = inv(Zf);
        Innf = struct('z',z,'Z',Zf,'iZ',iZf);

        % perform ekf update
        blockUpdateInn(rcr,pr,Hrc,Hp,Innf,'symmet')

        % robot quaternion normalization
        qr          = WDIM+1:WDIM+ODIM; % quat. range
        iqn         = 1/norm(Map.X(qr));
        Map.X(qr)   = Map.X(qr)*iqn;
%         Map.P(qr,:) = Map.P(qr,:)*iqn;
%         Map.P(:,qr) = Map.P(:,qr)*iqn;

        % camera quaternion normalization
        if prj == 2
            iqn         = 1/norm(Map.X(cr));
            Map.X(cr)   = Map.X(cr)*iqn;
%             Map.P(cr,:) = Map.P(cr,:)*iqn;
%             Map.P(:,cr) = Map.P(:,cr)*iqn;
        end

        % Robot and camera pose and matrices update
        Rob.X       = Map.X(rr);
        Rob         = updateFrame(Rob);
        Cam.X(cor)  = Map.X(cr);
        Cam         = updateFrame(Cam);

    end
end
