function dispImage = displImage(dispImage)

% DISPLIMAGE Display image

global Image

% image
for c = 1:2
    set(dispImage(c),'cdata',Image{c});
end
