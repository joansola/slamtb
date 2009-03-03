function [p,Pk,Pu,Pt] = homoInvPinHole(k,uu,t)

% HOMOINVPINHOLE Inverse pin-hole projection in homogeneous coordinates
%   HOMOINVPINHOLE(K,U,T) retroprojects homogeneous pixel P from a camera
%   with intrinsic parameters K = [u0 v0 au av]', using the homogeneous T.
%   The formula used is simply P = [K^-1*U ; T].
%
%   For ease of use, U is accepted to be a 2-vector. In this case, it is
%   homogenized by doing U = [U;1].

iK = invIntrinsic(k);

if numel(uu) == 2
    pix = [uu(:);1];
else
    pix = uu;
end

p = [iK*pix;t];

if nargout > 1 % we want Jacobians
    
    [u0,v0,au,av] = split(k);
    [u,v,w] = split(pix);

    Pk = [...
        [        -1/au*w,              0, (-u+u0*w)/au^2,              0]
        [              0,        -1/av*w,              0, (-v+v0*w)/av^2]
        [              0,              0,              0,              0]
        [              0,              0,              0,              0]];
    Pu = [iK;0 0 0];
    Pt = [0;0;0;1];

    if numel(uu) == 2
        Pu = Pu(:,1:2);
    end
end

return

%% Jac
syms u0 v0 au av u v w t real
k = [u0;v0;au;av];
uu = [u;v;w];

[p,Pk,Pu,Pt] = homoInvPinHole(k,uu,t);

simplify(Pk - jacobian(p,k))
Pu - jacobian(p,uu)
Pt - jacobian(p,t)

return


%%

% if ~isstruct(c)
%     cam.cal = c;
% end
%
% if ~isfield(cam,'undist')
%     if nargout < 2
%         p = homoRetro(depixellise(u,cam.cal),t);
%     else
%         [u,Uu,Uc] = depixellise(u,cam.cal);
%         [p,Pu,Pt] = homoRetro(u,t);
%         Pu  = Pu*Uu;
%         Pc  = Pu*Uc;
%     end
% else % all above with distortion correction
%     if nargout < 2
%         p = retro(undistort(depixellise(u,cam.cal),cam.undist),t);
%     else
%         [ud,UDu,UDc] = depixellise(u,cam.cal);
%         [u,Uud,Uundist] = undistort(ud,cam.undist);
%         [p,Pu,Pt] = homoRetro(u,t);
%         Pu  = Pu*Uud*UDu;
%         Pc  = Pu*Uud*UDc;
%         Pundist = Pu*Uundist;
%     end
% end
%
%
