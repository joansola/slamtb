function dir = pix2dir(pix,cal)

% PIX2DIR  Pixel to direction vector
%   PIX2DIR(PIX,CAL) Gives the direction vector in camera frame 
%   defined by the pixel PIX=[col row]  in a camera with
%   calibration parameters CAL=[u0 v0 au av]
%
%   If PIX is a pixel matrix, PIX2DIR(PIX,...) returns a
%   directions matrix DIR, with these matrices defined as
%     DIR = [d1 ... dn];       di = [xi;yi;1]
%     PIX = [pix1 ... pixn]; pixi = [ui;vi]
%
%   See also PINHOLE, INVPINHOLE

u = pix(1,:);
v = pix(2,:);

u0 = cal(1);
v0 = cal(2);
au = cal(3);
av = cal(4);

dir = [(u-u0)./au ; (v-v0)./av ; ones(1,length(u))];

