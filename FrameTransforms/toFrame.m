function [p_F,Tf,Tp] = toFrame(F,p_W)

% TOFRAME  Express in local frame a set of points from global frame.
%   TOFRAME(F,P_W)  takes the W-referenced points matrix P_W and
%   returns it in frame F.
%   P_W is a points matrix defined as
%     P_W = [P_1 P_2 ... P_N], where
%     P_i = [x_i;y_i;z_i]
%
%   F is either a structure containing at least:
%     t : frame position
%     q : frame orientation quaternion
%     Rt: transposed rotation matrix
%     Pc: Conjugated Pi matrix
%
%   or a 7-vector F = [t;q].
%
%   [p_F,Tf,Tp] = ... returns the Jacobians of toFrame:
%     Tf: wrt the frame [t;q]
%     Tp: wrt the point P_W
%   Note that this is only available for single points.
%
%   See also FROMFRAME, Q2PI, PI2PC, QUATERNION.

%   [1] Joan Sola, "Towards visual localization, mapping and moving objects
%   tracking by a moible robot," PhD dissertation, pages 181-183, Institut
%   National Politechnique de Toulouse, 2007.

s = size(p_W,2); % number of points in input matrix

[t,q,R,Rt,Pi,Pc] = splitFrame(F);

if s==1 % one point

    p_F = Rt*p_W - Rt*t;
   
    if nargout > 1 % Jacobians. See [1] for details.
        sc  = 2*Pc*(p_W-t);   % Conjugated s

        Tt  = -Rt;
        Tq  = [...
            sc(2)  sc(1) -sc(4)  sc(3)
            sc(3)  sc(4)  sc(1) -sc(2)
            sc(4) -sc(3)  sc(2)  sc(1)];
        Tp  = Rt;
        Tf  = [Tt Tq];
    end

else % multiple points
    p_F = Rt*p_W - Rt*repmat(t,1,s);
    if nargout > 1
        error('Can''t give Jacobians for multiple points');
    end
end