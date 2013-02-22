function [iF, IF_f] = invertFrame(F)

% INVERTFRAME  Invert frame.
%   INVERTFRAME(F)  gives the frame iF, inverse of F, so that its
%   composition is the origin frame:
%       O = COMPOSEFRAMES(F,iF) ==> O.x = [0 0 0 1 0 0 0]'
%
%   [iF, IF_f] = INVERTFRAME(F) returns tha Jacobian of the inversion.

if nargout == 1
    
    q = q2qc(F.q);
    t = -Rtp(F.q,F.t);
    iF.x = [t;q];
    iF = updateFrame(iF);
    
else
    
    [q, Q_q] = q2qc(F.q);
    [nt, nT_q, nT_t] = Rtp(F.q,F.t); % this should be -Rtp(). n** means negative.
    
    iF.x = [-nt;q];
    iF = updateFrame(iF);

    IF_f = zeros(7);
    IF_f(1:3,1:3) = -nT_t;
    IF_f(1:3,4:7) = -nT_q;
    IF_f(4:7,4:7) = Q_q;
    
end









