function [p_W,Ff,Fp] = fromFrame(F,p_F)

% FROMFRAME  Express in global frame a set of points from another frame
%   FROMFRAME(F,P_F)  takes the F-referenced points matrix P_F and 
%   returns it in the frame where F is referenced.
%   P_F is a points matrix defined as 
%     P_F = [P1 P2 ... PN], where
%     Pi  = [xi;yi;zi]
%
%   F is either a structure containing at least:
%     t : frame position
%     q : frame orientation quaternion
%     R : rotation matrix
%     Pi: Pi matrix
%
%   or a 7-vector F = [t;q].
%
%   [p_W,Ff,Fp] = ... returns the Jacobians of fromFrame:
%     Ff: wrt the frame
%     Fp: wrt the point
%   Note that this is only available for single points.
%
%   See also TOFRAME, Q2PI.

%   [1] Joan Sola, "Towards visual localization, mapping and moving objects
%   tracking by a moible robot," PhD dissertation, pages 181-183, Institut
%   National Politechnique de Toulouse, 2007.

s = size(p_F,2);

[t,q,R,Rt,Pi] = splitFrame(F);

if s==1 % one point
    p_W = R*p_F + t;
    
    if nargout > 1   % Jacobians. See [1] for details.
        s = 2*Pi*p_F;

        Ft = eye(3);
        Fq = [...
            s(2) -s(1)  s(4) -s(3)
            s(3) -s(4) -s(1)  s(2)
            s(4)  s(3) -s(2) -s(1)];
        Fp = R;
        Ff = [Ft Fq];
    end

else % multiple points
    p_W = R*p_F + repmat(t,1,s);
    if nargout > 1
        warning('Can''t give Jacobians for multiple points');
    end
end