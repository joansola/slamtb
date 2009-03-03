function v = R2v(R)

% R2V Rotation matrix to rotation vector conversion (inverse rodrigues
% formula)

% SQ = (R-R')/2;
% 
% su = [SQ(3,2) SQ(1,3) SQ(2,1)]'; % sinus times norm. vector
% s2 = su'*su; % squared sinus of rotation angle
% 
% s = whos('R');
% 
% if strcmp(s.class,'sym') || s2 > 1e-8
%     sina = sqrt(s2);
%     a = asin(sina);
% 
%     v = a*su/sina;
% else
%     v = zeros(3,1);
% end
% 


% project the rotation matrix to SO(3);
[U,S,V] = svd(R);
R = U*V';

tr    = (trace(R)-1)/2;
theta = real(acos(tr));

% dtrdR = [1 0 0 0 1 0 0 0 1]/2;


if sin(theta) >= 1e-5,

    vth = 1/(2*sin(theta));
    om1 = [R(3,2)-R(2,3), R(1,3)-R(3,1), R(2,1)-R(1,2)]';
    om  = vth*om1;
    v   = om*theta;

%     % Jacobian
%     dthetadtr   = -1/sqrt(1-tr^2);
%     dthetadR    = dthetadtr * dtrdR;
%     dvthdtheta  = -vth*cos(theta)/sin(theta);
%     dvar1dtheta = [dvthdtheta;1];
%     dvar1dR     =  dvar1dtheta * dthetadR;
%     dom1dR      = [0  0  0  0  0  1  0 -1  0;
%                    0  0 -1  0  0  0  1  0  0;
%                    0  1  0 -1  0  0  0  0  0];
%     domdvar     = [vth*eye(3) om1 zeros(3,1)];
%     dthetadvar  = [0 0 0 0 1];
%     dvardR      = [dom1dR;dvar1dR];
%     dvar2dvar   = [domdvar;dthetadvar];



else
    if tr > 0; 			% case norm(om)=0;
        v = [0 0 0]';
    else 				% case norm(om)=pi; %% fixed April 6th
        v = theta * (sqrt((diag(R)+1)/2).*[1;2*(R(1,2:3)>=0)'-1]);
    end;
end;

