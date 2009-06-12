function e = trimLine(hm,imSize)

% TRIMLINE  Trim homogeneous line at image borders.
%   TRIMLINE(HM,IMSIZE) trims the homogeneous line HM at the image borders
%   specified by IMSIZE. IMSIZE is a 2-vector with the image dimensions in
%   pixels, IMSIZE = [HSIZE,VSIZE]. The output is a 4-vector segment with
%   both endpoints lying at the image borders. If the line is not visible,
%   the returned segment is empty, ie. a 0-vector.
%
%   See also TRIMSEGMENT.

%   (c) 2008 Joan Sola @ LAAS-CNRS


% image witdh and height
[w,h] = split(imSize);


L = [1; 0; 0];  % left image border
R = [1; 0;-w];  % right
T = [0; 1; 0];  % top
B = [0; 1;-h];  % bottom

% intersections of infinite line with infinite borders
HL = hh2p(hm,L,1);
HR = hh2p(hm,R,1);
HT = hh2p(hm,T,1);
HB = hh2p(hm,B,1);

% bring to image borders
i = 1;
if inInterval(HL(2),[0,h])
    e(i:i+1,1) = HL;
    i = 3;
end
if inInterval(HR(2),[0,h])
    e(i:i+1,1) = HR;
    i = 3;
end
if inInterval(HT(1),[0,w])
    e(i:i+1,1) = HT;
    i = 3;
end
if inInterval(HB(1),[0,w])
    e(i:i+1,1) = HB;
end

if i == 1 % no intersection with image borders
    % Line is not visible
    e = [];
end

return

%% test
imsize = [10 10];
hm = randn(3,1);

hm
(trimLine(hm,imsize))'

