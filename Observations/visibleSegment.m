function [sv,vis] = visibleSegment(s,d,imSize)

% VISIBLESEGMENT  Visible segment.
%   VISIBLESEGMENT(S,D,IMSIZE) returns the segment portion of segment S
%   that is visible in the image defined by IMSIZE. D is a vector of depths
%   of the two segment's endpoints.
%
%   [SV,VIS] = VISIBLESEGMENT(...) returns the visible segment SV and a
%   flag of visibility. In case of non visibility, the flag is set to false
%   and the output segment is SV = [0;0;0;0].
%
%   The function works for segment matrices S = [S1 S2 ... Sn] and D = [D1
%   D2 ... Dn].

n   = size(s,2);
sv  = zeros(4,n);
vis = zeros(1,n);


for i = 1:n
    a = s(1:2,i);
    b = s(3:4,i);
    ad = d(1,i);
    bd = d(2,i);

    if ad<0 && bd<0 % not visible
        sv(:,i) = zeros(4,1);
        vis(i) = false;
    else
        vis(i) = true;
        
        u = normvec(b-a); % uncorrected direction
        if ad<0           % endpoint A is behind the camera
            a = b + 1e8*u;
        elseif bd<0       % endpoint B is behind the camera
            b = a - 1e8*u;
        end

        if nargin == 3
            ss = trimSegment([a;b],imSize);
            if numel(ss) == 0 % not visible
                sv(:,i) = zeros(4,1);
                vis(i) = false;
            else
                sv(:,i) = ss; % visible
            end
        end
    end
end
