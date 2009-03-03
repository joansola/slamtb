function [sc,k,scMax,kMax,pixMax] = lineScan(patch,pix,dir,threshold,xm,P,ns)

% LINESCAN  Correlation score along a line
%   SC = LINESCAN(PATCH,PIX0,DIR,SCANSTEP,XM,P,NS,TH) scans the line
%   of pixel PIX0 in the direction DIR until
%   the out-of-ellipse condition is met or the correlation
%   score surpasses the threshold TH. The ellipse 
%   corresponds to the NS-sigma bound of the 2D-Gaussian
%   defined by the mean XM and the covariance P.
%   The scores of all scanned pixels are returned in
%   the line-vector SC.
%
%   [SC,K] = LINESCAN(...) returns also the number K of
%   pixels scanned.
%
%   [SC,K,SCMAX,KMAX] = ... returns the maximum score and the index at
%   which it is located.
%
%   See also PATCHCORR, COV2ELLI, ISINSIDE

global scanPix

k = 0;
kMax = -1;
pixMax = pix;
scMax = -1;

while isInElli(pix,xm,P,ns)
%     set(scanPix,'xdata',pix(1),'ydata',pix(2));
%     drawnow
%     pause(.1)

    sc(k+1) = patchCorr(pix,patch,'zncc');
    
    if (sc(k+1) > threshold) || (scMax > threshold)
        if sc(k+1) > scMax
            scMax = sc(k+1);
            kMax = k;
            pixMax = pix;
        else
            break
        end
    end
    
    k = k+1;
    pix(1) = pix(1)+dir; % next pixel
end
