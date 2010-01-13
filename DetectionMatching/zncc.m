function sc = zncc(I,J,SI,SII,SJ,SJJ)

% ZNCC  Zero mean, Normalized Correlation Coefficient
%   ZNCC(I,J) computes the zncc score of matrices I and J:
%
%     ZNCC = 1/N*sum((I-mean(I))*(J-mean(J)))/(std(I)*std(J))
%
%   where N = prod(size(I))
%   and   size(I) = size(J)
%
%   ZNCC(I,J,SI,SII,SJ,SJJ) accepts useful intermediate results
%   that permit to speed up the calculations. These are:
%
%     SI  = sum(sum(I))
%     SII = sum(sum(I.*I))
%     SJ  = sum(sum(J))
%     SJJ = sum(sum(J.*J))
%
%   See also PATCHCORR, SSD, CENSUS

switch nargin
    case 6
        SIJ = sum(sum(I.*J));
    case 5
        SJJ = sum(sum(I.*I));
        SIJ = sum(sum(I.*J));
    case 4
        SJ  = sum(sum(J));
        SJJ = sum(sum(J.*J));
        SIJ = sum(sum(I.*J));
    case 3
        SII = sum(sum(I.*I));
        SJ  = sum(sum(J));
        SJJ = sum(sum(J.*J));
        SIJ = sum(sum(I.*J));
    case {1,2}
        SI  = sum(sum(I));
        SII = sum(sum(I.*I));
        SJ  = sum(sum(J));
        SJJ = sum(sum(J.*J));
        SIJ = sum(sum(I.*J));
end

N = numel(I);

% This is the eqquivalent, faster formula than that given
% in the help section:
%
%   sc = (N*SIJ - SI*SJ)/sqrt((N*SII - SI^2)*(N*SJJ - SJ^2)+eps);
%
% we make a test on the variance of I and J to avoid degenerated cases

den = (N*SII - SI^2)*(N*SJJ - SJ^2);

if den < N
%     figure(5);image(J);colormap(gray(255));axis image
    sc = 0;
else
    sc = (N*SIJ - SI*SJ)/sqrt(den);
end


    
