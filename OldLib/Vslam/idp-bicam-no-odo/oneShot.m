function Image = oneShot(imgname,f,eq)

% ONESHOT  Take one gray level picture from general picture file.
%   ONESHOT(FILE,F) reads the picture frame F from the images
%   series contained in the file template FILE. Tis template FILE
%   is in the standard 'C' language as in the FPRINTF function.
%   The input images can be in any format supported by IMREAD.
%   ONESHOT always returns a gray level image matrix of class 'single'.
%
%   ONESHOT(...,EQ) performs histogram equalization if EQ == true.
%
%   Example: 
%   The directory /Data/images/ contains the RGB image files:
%
%     im001.png  im002.png  im001.small.png  im002.small.png
%
%   then 
%
%     I = ONESHOT('/Data/images/im%03d.png',2) 
%
%   returns a gray level version of the image stored in im002.png.
%
%   See also IMREAD, HISTEQ, SINGLE, FPRINTF.


ima   = single(imread(sprintf(imgname,f)));

if exist('eq','var') && eq
    if size(ima,3) ~= 1
        Image = (histeq(sum(ima,3)/3));
    else
        Image = (histeq(ima));
    end
else
    if size(ima,3)~= 1
        Image = (sum(ima,3)/3);
    else
        Image = (ima);
    end
end
