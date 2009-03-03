function [pixMax,scMax,scIm] = localScan(patch,pix0,scMax,scIm)

global scanPix

pixMax = pix0;
iMax = 0;
jMax = 0;

for i = -2:2
    for j = -2:2
        pix = pix0 + [i;j];
        if (mod(i,2) ~= 0) || (mod(j,2) ~= 0)
            scIm(j+3,i+3) = patchCorr(pix,patch,'zncc');
            if scIm(j+3,i+3) > scMax
                scMax = scIm(j+3,i+3);
                pixMax = pix;
                iMax = i;
                jMax = j;
            end
                
%             set(scanPix,'xdata',pix(1),'ydata',pix(2));
%             image((1+scIm)*127)
%             axis image
%             drawnow
%             pause(.05)
            
        end

    end
end

scIm = scIm(2+jMax:4+jMax,2+iMax:4+iMax);

