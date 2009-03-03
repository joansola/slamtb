function [pixMax,scMax,sc] = localScan(patch,pix0,sc0)

global scanPix

neighbours = [-1  0  1 -1  1 -1  0  1;
    -1 -1 -1  0  0  1  1  1];

sze = size(neighbours,2);
sc  = zeros(1,sze);
pix = zeros(2,sze);

for i = 1:sze
    pix(:,i) = pix0 + neighbours(:,i);
    sc(i) = patchCorr(pix(:,i),patch,'zncc');
    
%     set(scanPix,'xdata',pix(1,i),'ydata',pix(2,i));
%     drawnow
%     pause(.1)
end

scMax = max(sc);
if scMax > sc0
    [scMax,iMax] = find(sc==scMax);
    pixMax = pix(:,iMax);
    scMax = sc(iMax);
else
    pixMax = pix0;
    scMax = sc0;
end