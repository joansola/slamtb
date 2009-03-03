function Rob = FISUpdate(Rob,Ray,Obs)

% FISUPDATE  Ray update using FIS

global Map WDIM ODIM

for i = 1:Ray.n % for every point in the ray

    % get Ray parameters
    w    = Ray.w(i);

    if w > 0.05 % update only if the effect is noticeable
        
        loc  = Ray.loc(i);
        z    = Ray.z(:,i);
        Hr   = Ray.Hr(:,:,i);
        Hp   = Ray.Hp(:,:,i);
        U    = Ray.U(:,:,i);

        % Other parameters
        r  = Rob.r;
        pr = loc2range(loc);
        R  = Obs.R;

        % compute federated coefficient
        rho = w;

        % Federated covariance
        Rf = R/rho;

        % Federated innovation covariance and inverse
        Zf  = U + Rf;    % now:  Zf = HPH' + R/rho
        iZf = inv(Zf);

        % Federated innovation
        Innf = struct('z',z,'Z',Zf,'iZ',iZf);

        % perform ekf update
        %     blockUpdateInn(r,pr,Hr,Hp,Innf,'symmet')
        blockUpdateInn(r,pr,Hr,Hp,Innf,'simple')

        % quaternion normalization
        qr  = WDIM+1:WDIM+ODIM; % quat. range
        iqn = 1/norm(Map.X(qr));
        Map.X(qr)   = Map.X(qr)*iqn;
        Map.P(qr,:) = Map.P(qr,:)*iqn;
        Map.P(:,qr) = Map.P(:,qr)*iqn;


        % Robot pose and matrices update
        Rob.X = Map.X(r);
        updateFrame(Rob);

    end
end
