function recTab = inRectangle(tab,r,u1,v1,u2,v2)

% INRECTANGLE  Select points inside a rectangle
%   RECTAB = INRECTANGLE(TAB,RNG,U1,V1,U2,V2) selects the
%   points in TAB that are inside the rectangle defined
%   by U1...V2. 
%   TAB is a table of points [p1 ... pn] where
%     pi = [...;u;v;...], being RNG the indices range
%     to locate u and v, the pixel coordinates of pi.
%
%   See also CLASSIFY, CLASSIFYOBS


um = (u1+u2)/2;
ud = (u2-u1)/2;
vm = (v1+v2)/2;
vd = (v2-v1)/2;

Tu = tab(r(1),:);

iu = find(ud>abs(Tu-um));

Ru = tab(:,iu);

Tv = Ru(r(2),:);

iv = find(vd>abs(Tv-vm));

recTab = Ru(:,iv);

