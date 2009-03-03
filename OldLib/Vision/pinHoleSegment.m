function [s,vis] = pinHoleSegment(k,S,imSize)

% PINHOLESEGMENT  Pin hole image of a segment.
%   PINHOLESEGMENT(K,S) is the pin-hole image of the segment S into a
%   camera with intrinsic parameters K = [u0 v0 au av]. The input segment S
%   is a 6-vector of the two stacked Euclidean 3-endpoints. The returned
%   segment is a 4-vector of the 2 stacked Euclidean 2-points.
%
%   PINHOLESEGMENT(K,S,IMSIZE) accepts the image size IMSIZE=[HSIZE,VSIZE]
%   with which the output segment is trimmed.
%
%   See also PINHOLE, TRIMSEGMENT.

A = S(1:3,:);
B = S(4:6,:);

[ao,ad] = pinHole(A,k);
[bo,bd] = pinHole(B,k);

for i = 1:size(ao,2)
    a = ao(:,i);
    b = bo(:,i);

    if ad(i)<0 && bd(i)<0 % not visible
        s(:,i) = zeros(4,1);
        vis(i) = false;
    else
        vis(i) = true;
        
        u = normvec(b-a); % uncorrected direction
        if ad(i)<0           % endpoint A is behind the camera
            a = b + 1e8*u;
        elseif bd(i)<0       % endpoint B is behind the camera
            b = a - 1e8*u;
        end

        if nargin == 3
            ss = trimSegment([a;b],imSize);
            if numel(ss) == 0 % not visible
                s(:,i) = zeros(4,1);
                vis(i) = false;
            else
                s(:,i) = ss; % visible
            end
        end
    end
end