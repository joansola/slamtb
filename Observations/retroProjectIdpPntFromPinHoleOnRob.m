

function idp_W = retroProjectIdpPntFromPinHoleOnRob(Rf, Sf, Sk, Sd, point, inv_depth)


% RETROPROJECTIDPPNTFROMPINHOLEONROB De-Project idp point into Pin-hole
% camera model on robot.
%   IDP_W = RETROPROJECTIDPPNTFROMPINHOLEONROB(RF, SF, SK, SD, POINT,
%   INV_DEPTH) gives the retroprojected IDP in World Frame from an
%   observation. RF and SF are Robot and Sensor Frames, SK and SD are
%   camera parameters. POINT is the pixel coordinate and INV_DEPTH is the
%   non-observable part of the measuerment.
%    
%   IDP_W is a 6 variables vector :
%     IDP_W = [X Y Z Pitch Yaw IDepth]'
%   
%   See also INVPINHOLEIDP, FROMFRAMEIDP, COMPOSEFRAMES.



% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

if(isempty(Sd))
    % IDP in Sensor Frame
    idp_S = invPinHoleIdp(point,inv_depth,Sk) ;
else
    % IDP in Sensor Frame
    idp_S = invPinHoleIdp(point,inv_depth,Sk,Sd) ;
end ;

% idp_S = [0; 0; 0; pitch_sen; yaw_sen; rho_sen]
% idp_W = [x0, pitch, yaw, rho]'
% with :
%   x0 = camera position:
%         x0 = fromFrame(Rob(rob).frame,Sen(sen).frame.t)
%   py_sen = [pitch_sen; yaw_sen], angles in sensor Frame. So:
%   py = vec2py(R_rob*R_sen*py2vec(py_sen))
%         R_rob = Rob(rob).frame.R
%         R_sen = Sen(sen).frame.R
%   rho = rho_sen

x0 = fromFrame(Rf,Sf.t) ;
py = vec2py(Rf.R*Sf.R*py2vec(idp_S(4:5))) ;
idp_W = [x0 ; py ; idp_S(6)] ;

end


