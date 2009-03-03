function [sqx,sqy] = box2sq(xm,xM,ym,yM)

% BOX2SQ  rectangular box to square line
%   [SQX,SQY] = BOX2SQ(xm,xM,ym,yM)

sqx = [xm xm xM xM xm];
sqy = [ym yM yM ym ym];
