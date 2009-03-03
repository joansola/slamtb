function [S_W,SW_f,SW_sf] = fromFrameSegment(F,S_F)

% FROMFRAMESEGMENT  Express in global frame a set of segments from local frame
%   FROMFRAMESEGMENT(F,S_F)  takes the F-referenced segments matrix S_F and
%   returns it in global frame W.
%   S_F is a segments matrix defined as
%       S_F  = [S_1 S_2 ... S_N], where
%       S_I  = [P_i1;P_i2]      are the segments
%       P_ij = [x_ij;y_ij;z_ij] are the segments' endpoints
%
%   F is either a structure containing at least:
%     t : frame position
%     q : frame orientation quaternion
%     Rt: transposed rotation matrix
%     Pc: Conjugated Pi matrix
%
%   or a 7-vector F = [t;q].
%
%   [S_W,SW_f,SW_sf] = ... returns the Jacobians of fromFrameSegments:
%     SW_f:  wrt the frame
%     SW_sf: wrt the segment
%   Note that this is only available for single segments.
%
%   See also FROMFRAME.

s = size(S_F,2); % number of points in input matrix

if s==1 % one segment

    S_W = [...
        fromFrame(F,S_F(1:3))
        fromFrame(F,S_F(4:6))];
   
    if nargout > 1 % Jacobians
        [P1_W,P1W_f,P1W_p1f] = fromFrame(F,S_F(1:3,:));
        [P2_W,P2W_f,P2W_p2f] = fromFrame(F,S_F(4:6,:));
        S_W = [P1_W;P2_W];
        SW_f = [P1W_f;P2W_f];
        SW_sf = [P1W_p1f zeros(3);zeros(3) P2W_p2f];
    end

else % multiple points
    
    S_W = [...
        fromFrame(F,S_F(1:3,:))
        fromFrame(F,S_F(4:6,:))];
    if nargout > 1
        warning('Can''t give Jacobians for multiple segments');
    end
end