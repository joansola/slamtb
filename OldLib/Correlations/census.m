function sc = census(I,J)

% CENSUS  Census Correlation coefficient
%   CENSUS(I,J) computes the census score of matrices I and J:
%
%     CENSUS = 1/N * ~xor( I > Io , J > Jo )
%
%   where N  = prod(size(I))
%         Io = I(central pixel)
%         Jo = J(central pixel)
%   and   size(I) = size(J)
%
%   See also PATCHCORR, ZNCC, SSD

% (c) 2005 Joan Sola


if size(I) ~= size(J)
    error ('Matrices must be the same size.')
else
    s = size(I); % patch size
    if any(iseven(s))
        error('Matrix sizes must be odd.')
    else
        c = (s+1)/2; % patch center
        i = I(c(1),c(2)); % central pixel
        j = J(c(1),c(2)); % central pixel

        V = I > i;
        W = J > j;

        SC = ~xor(V,W);
        sc = sum(sum(SC))/numel(I);
    end
end
