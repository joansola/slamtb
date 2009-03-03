function [pix,sc] = Nharris(im,N,mrg,sgm,th,rd,method)

% NHARRIS  Get N Harris points
%   [PIX,SC] = NHARRIS(IM,N,M,SGM,TH,RD,MET) gets the N best
%   Harris points of image IM, using the options SGM, TH, RD and
%   MET as sigma, threshold, radius and method in the function
%   HARRIS. The output is as follows:
%     PIX = [p1 p2 ... pN] where pi = [ui;vi] with ui: horizontal
%     coordinate, origin at upper left corner, and vi: vertical
%     coordinate. SC = [sc1 sc2 ... scN] is the score of each
%     returned point.
%
%   All harris points closer to the image limits than M pixels
%   are not returned. M is obligatory: if this performance is not
%   desired, set M=0.
%
%   See also HARRIS

%   (c) 2005 Joan Sola

if N > 1
    [r,c,sc] = harris(im,sgm,th,rd,method,0);
    rs = size(im,1);
    cs = size(im,2);

    r  = r(:)';
    c  = c(:)';
    sc = sc(:)';

    sc(c<mrg|c>cs-mrg) = [];
    r(c<mrg|c>cs-mrg) = [];
    c(c<mrg|c>cs-mrg) = [];

    sc(r<mrg|r>rs-mrg) = [];
    c(r<mrg|r>rs-mrg) = [];
    r(r<mrg|r>rs-mrg) = [];


    n = min(N,length(r));

    [sc,si] = sort(sc,'descend');

    si = si(1:n);

    pix = [c(si);r(si)];

    sc = sc(1:n);


else % only strongest point
    
    [pix,sc] = harris_strongest(im,sgm,mrg);
    if sc < th
        pix = [];
        sc  = [];
    end
end

