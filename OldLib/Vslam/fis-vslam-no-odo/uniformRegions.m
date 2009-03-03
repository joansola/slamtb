function region = uniformRegions(Vsze,Hsze,r,c,rm,cm,minReg)

% UNIFORMREGIONS  Define image regions uniformly
%   R = UNIFORMREGIONS(VSZE,HSZE,R,C,RM,CM,MINREG)  divides the
%   region of  size [VSZE HSZE] in RxC blocks or sub-regions,
%   rejects RM sub-region rows from up and down and CM
%   columns from left and right, and returns a structure array
%   R corresponding to each central sub-region with the
%   following fields:
%     .u0     : the upper-left coordinates of the sub-region
%     .size   : the size of the sub-region
%     .numPnt : number of points in region
%     .numRay : number of rays in region
%     .numLmk : number of landmarks (points and rays)
%     .numInit: number of lmks to initialize
%     .minReg : minimum desired # of landmarks
%     .nrows  : number of rows
%     .ncols  : number of columns
%
%   MINREG is a row vector with the minimum number of desired
%   landmarks in each region, counting left to right, up to down.
%   It is an error if length(MINREG) ~= (R-2*RM)*(C-2*CM).

% (c) 2005 Joan Sola

if length(minReg) == (r-2*rm)*(c-2*cm)

    v0 = round((0:r-1)*Vsze/r);
    h0 = round((0:c-1)*Hsze/c);

    dv = v0(2+rm:end-rm+1)-v0(1+rm:end-rm);
    dh = h0(2+cm:end-cm+1)-h0(1+cm:end-cm);

    v0 = v0(1+rm:end-rm);
    h0 = h0(1+cm:end-cm);

    region.nrows = r-2*rm;
    region.ncols = c-2*cm;
    
    for j=1:region.nrows
        for i=1:region.ncols
            idx = i + region.ncols*(j-1);
            region.u0(:,idx)    = [h0(i);v0(j)];
            region.size(:,idx)  = [dh(i);dv(j)];
            region.numPnt(idx)  = 0;
            region.numRay(idx)  = 0;
            region.numLmk(idx)  = 0;
            region.numInit(idx) = 0;
            region.minReg(idx)  = minReg(idx);
        end
    end
    %i=1;

else
    error('MINREG vector length does not fit the number of regions')
end
