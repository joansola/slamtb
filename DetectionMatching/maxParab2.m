% MAXPARAB2 Maximum point of a 2D parabolloid.

function xm = maxParab2(yc,yl,yr,yu,yd)

% MAXPARAB2(YC,YW,YE,YN,YS)

hm = maxParab(yc,yl,yr);
vm = maxParab(yc,yu,yd);

xm = [hm;vm];










