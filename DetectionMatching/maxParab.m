function xm = maxParab(yc,yl,yr)

a = (yl+yr)/2-yc;
b = (yr-yl)/2;
% c = yc;   % not used

if abs(a) > eps
    xm = -b/2/a;
else
    xm = 0;
end
