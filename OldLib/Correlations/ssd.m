function sc = ssd(I,J,SII,SJJ)

% SSD  Sum of Squared Differences coefficient
%   SSD(I,J) computes the SSD score of matrices I and J:
%
%     SSD = 1/N*sum((I-J).^2)
%     
%   where N = prod(size(I)) 
%   and   size(I) = size(J)
%
%   SSD(I,J,SII,SJJ) accepts useful intermediate results
%   that permit to speed up the calculations. These are:
%
%     SII = sum(sum(I.*I))
%     SJJ = sum(sum(J.*J))
%
%   See also PATCHCORR, ZNCC, CENSUS

% (c) 2005 Joan Sola

if size(I) ~= size(J)
    error ('Matrices must be the same size.')
else
    switch nargin
        case {1,2}
            SII = sum(sum(I.*I));
            SJJ = sum(sum(J.*J));
        case 3
            SJJ = sum(sum(J.*J));
    end
    
    SIJ = sum(sum(I.*J));
    
    N   = numel(I);
    
    sc  = sqrt((SII+SJJ-2*SIJ)/(N+eps));

end
