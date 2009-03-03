function Image = doubleShot(imgname,f,eq)

% DOUBLESHOT  Take a double picture shot.
%   I = DOUBLESHOT(FILE,F) reads the picture frame F from the
%   images series contained in the file templates defined in
%   FILE. This template FILE is in the standard 'C' language as
%   in the FPRINTF function. The file names are automatically
%   completed with the termination '.g' and '.d' for left and
%   right images respectively, but the file template must contain
%   the '%s' chain at the desired location. The input images can
%   be in any format supported by IMREAD. ONESHOT always returns
%   a gray level image matrix of class 'single'. I is a cell
%   array with the two images, I{1} for the left and I{2} for the
%   right.
%
%   I = DOUBLESHOT(...,EQ) performs histogram equalization if EQ
%   == true.
%
%   Example: The directory /Data/images/ contains the RGB image
%   files:
%
%     im001.g.png  im002.d.png  im001.small.g.png
%     im002.small.d.png
%
%   then 
%
%     I = DOUBLESHOT('/Data/images/im%03d%s.png',2) 
%
%   returns two gray level versions I{1} and I{2} of the images
%   stored in im002.d.png and im002.g.png.
%
%   See also ONESHOT, IMREAD, HISTEQ, SINGLE, FPRINTF.

file1 = sprintf(imgname,f,'.g');
file2 = sprintf(imgname,f,'.d');
ima1   = imread(file1);
ima2   = imread(file2);
if exist('eq','var') && eq
    if size(ima,3) ~= 1
        Image{1} = single(histeq(rgb2gray(ima1)));
        Image{2} = single(histeq(rgb2gray(ima2)));
    else
        Image{1} = single(histeq(ima1));
        Image{2} = single(histeq(ima2));
    end
else
    if size(ima1,3)~= 1
        Image{1} = single(rgb2gray(ima1));
        Image{2} = single(rgb2gray(ima2));
    else
        Image{1} = single(ima1);
        Image{2} = single(ima2);
    end
end

